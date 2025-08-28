module Types
  class CartType < Types::BaseObject
    field :id, ID, null: false
    field :items, [Types::CartItemType], null: true, method: :cart_items
    field :cart_items, [Types::CartItemType], null: true
    field :total_price, Float, null: false

    def cart_items
      object.cart_items
    end

    def total_price
      object.cart_items.sum { |item| item.product.price * item.quantity }
    end
  end
end