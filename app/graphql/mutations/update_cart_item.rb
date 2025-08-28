# app/graphql/mutations/update_cart_item.rb
module Mutations
  class UpdateCartItem < BaseMutation
    argument :product_id, ID, required: true
    argument :quantity, Integer, required: true
    field :cart, Types::CartType, null: true
    field :errors, [String], null: false

    def resolve(product_id:, quantity:)
      user = context[:current_user]
      return { cart: nil, errors: ["Not authenticated"] } unless user

      cart = user.cart
      return { cart: nil, errors: ["Cart not found"] } unless cart

      item = cart.cart_items.find_by(product_id: product_id)
      return { cart: nil, errors: ["Item not found"] } unless item

      if quantity <= 0
        item.destroy
      else
        item.update(quantity: quantity)
      end

      { cart: cart, errors: [] }
    end
  end
end
