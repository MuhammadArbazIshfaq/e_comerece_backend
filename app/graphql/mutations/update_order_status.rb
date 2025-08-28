module Mutations
  class UpdateOrderStatus < BaseMutation
    argument :order_id, ID, required: true
    argument :status, String, required: true

    field :order, Types::OrderType, null: true
    field :errors, [String], null: false

    VALID_STATUSES = %w[pending confirmed shipped delivered canceled]

    def resolve(order_id:, status:)
      user = context[:current_user]
      return { order: nil, errors: ["Not authenticated"] } unless user
    authorize_admin!

      order = Order.find_by(id: order_id)
      return { order: nil, errors: ["Order not found"] } unless order

      unless VALID_STATUSES.include?(status)
        return { order: nil, errors: ["Invalid status"] }
      end

      if order.update(status: status)
        { order: order, errors: [] }
      else
        { order: nil, errors: order.errors.full_messages }
      end
    end
  end
end
