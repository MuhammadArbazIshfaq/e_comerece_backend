# module Queries
#   class AdminOrders < Queries::BaseQuery
#     type [Types::OrderType], null: false

#     def resolve
#       user = context[:current_user]
#       authorize_admin!

#       Order.all.order(created_at: :desc)
#     end
#   end
# end
