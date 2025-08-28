# app/graphql/mutations/add_to_cart.rb
module Mutations
  class AddToCart < BaseMutation
    argument :product_id, ID, required: true
    argument :quantity, Integer, required: false, default_value: 1

    field :cart, Types::CartType, null: true
    field :errors, [String], null: false

    def resolve(product_id:, quantity:)
      user = context[:current_user]
      return { cart: nil, errors: ["Not authenticated"] } unless user

      cart = user.cart || user.create_cart
      item = cart.cart_items.find_or_initialize_by(product_id: product_id)
      
      # Initialize quantity to 0 if it's a new item (nil), then add the requested quantity
      item.quantity = (item.quantity || 0) + quantity
      
      if item.save
        { cart: cart.reload, errors: [] }
      else
        { cart: nil, errors: item.errors.full_messages }
      end
    rescue => e
      { cart: nil, errors: [e.message] }
    end
  end
end
