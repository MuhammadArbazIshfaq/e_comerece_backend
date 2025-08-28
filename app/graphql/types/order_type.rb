module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :total, Float, null: false
    field :status, String, null: false
    field :order_items, [Types::OrderItemType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::UserType, null: true
  end
end
