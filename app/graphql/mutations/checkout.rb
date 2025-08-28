module Mutations
  class Checkout < BaseMutation
    argument :shipping_address, String, required: false
    argument :payment_method, String, required: false
    argument :notes, String, required: false

    field :order, Types::OrderType, null: true
    field :errors, [String], null: false

  def resolve(shipping_address: nil, payment_method: nil, notes: nil)
  user = context[:current_user]
  return { order: nil, errors: ["Not authenticated"] } unless user

  cart = user.cart
  return { order: nil, errors: ["Cart is empty"] } if cart.nil? || cart.cart_items.empty?

  ActiveRecord::Base.transaction do
    order = user.orders.create!(
      total: cart.cart_items.sum { |item| item.quantity * item.product.price },
      status: "pending",
      shipping_address: shipping_address,
      payment_method: payment_method,
      notes: notes
    )

    cart.cart_items.each do |item|
      product = item.product

      # Check stock availability
      if product.stock < item.quantity
        raise ActiveRecord::Rollback, "Not enough stock for #{product.name}"
      end

      # Deduct stock
      product.update!(stock: product.stock - item.quantity)

      # Create order item
      order.order_items.create!(
        product: product,
        quantity: item.quantity,
        price: product.price
      )
    end

    cart.cart_items.destroy_all

    { order: order, errors: [] }
  end
rescue => e
  { order: nil, errors: [e.message] }
end

  end
end
