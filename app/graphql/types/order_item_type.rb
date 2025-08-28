module Types
  class OrderItemType < Types::BaseObject
    field :id, ID, null: false
    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :product, Types::ProductType, null: false
  end
end
