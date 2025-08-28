# app/graphql/mutations/remove_from_cart.rb
module Mutations
  class RemoveFromCart < BaseMutation
    argument :product_id, ID, required: true

    field :cart, Types::CartType, null: true
    field :errors, [String], null: false

    def resolve(product_id:)
      user = context[:current_user]
      return { cart: nil, errors: ["Not authenticated"] } unless user

      cart = user.cart
      return { cart: nil, errors: ["Cart not found"] } unless cart

      item = cart.cart_items.find_by(product_id: product_id)
      return { cart: nil, errors: ["Item not found"] } unless item

      item.destroy
      { cart: cart, errors: [] }
    end
  end
end
