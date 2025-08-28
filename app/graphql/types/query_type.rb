# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include Helpers::AuthorizationHelper
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end


    field :me, Types::UserType, null: true,
      description: "Return the current logged-in user"
def me
  context[:current_user]
end

      field :products, [Types::ProductType], null: false

def products
Product.all
end

field :product, Types::ProductType, null: true do
  argument :id, ID, required: true
end
def product(id:)
  Product.find_by(id: id)
end

field :categories, [Types::CategoryType], null: false

def categories
  Category.all
end

field :category, Types::CategoryType, null: true do
  argument :id, ID, required: true
end
def category(id:)
  Category.find_by(id: id)
end
# app/graphql/types/query_type.rb
field :my_cart, Types::CartType, null: true do
  description "Fetch the current user's cart"
end

def my_cart
  context[:current_user]&.cart || Cart.create(user: context[:current_user])
end


field :order_history, [Types::OrderType], null: false

def order_history
  user = context[:current_user]
  raise GraphQL::ExecutionError, "Not authenticated" unless user

  user.orders.order(created_at: :desc)
end


 field :admin_orders, [Types::OrderType], null: false,
          description: "List all orders (admin only)"

    def admin_orders
      user = context[:current_user]
      authorize_admin!

      Order.all.order(created_at: :desc)
    end
  end
end
