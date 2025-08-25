# app/graphql/mutations/signup_user.rb
module Mutations
  class SignupUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, String, required: false, default_value: "customer"

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(name:, email:, password:, role:)
      ActiveRecord::Base.transaction do
        user = User.new(name: name, email: email, password: password, role: role)

        if user.save
          begin
            token = JsonWebToken.encode(user_id: user.id)
            { user: user, token: token, errors: [] }
          rescue => e
            raise ActiveRecord::Rollback  # rollback user creation
          end
        else
          { user: nil, token: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end

