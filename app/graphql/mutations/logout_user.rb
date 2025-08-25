# app/graphql/mutations/logout_user.rb
module Mutations
  class LogoutUser < BaseMutation
    field :success, Boolean, null: false
    argument_class Types::BaseArgument

    def resolve
      context[:response].delete_cookie(:jwt)
      { success: true }
    end
  end
end
