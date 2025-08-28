module Helpers
  module AuthorizationHelper
     def authorize_admin!
      user = context[:current_user]
      raise GraphQL::ExecutionError, "You must be logged in!" unless user
      raise GraphQL::ExecutionError, "You are not authorized!" unless context[:current_user]&.role == "admin"
    end
  end
end
