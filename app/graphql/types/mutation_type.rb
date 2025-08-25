module Types
  class MutationType < Types::BaseObject
    field :signup_user, mutation: Mutations::SignupUser
    field :login_user, mutation: Mutations::LoginUser
    field :logout_user, mutation: Mutations::LogoutUser
  end
end
