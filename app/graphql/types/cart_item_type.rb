module Types
  class CartItemType < Types::BaseObject
    field :id, ID, null: false
    field :product, Types::ProductType, null: false
    field :quantity, Integer, null: false
  end
end