# app/graphql/mutations/signup_user.rb
module Mutations
  class SignupUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :role, String, required: false, default_value: "customer"

    field :user, Types::UserType, null: true
    field :token, String, null: true  # Keep this for backwards compatibility
    field :errors, [String], null: false

    def resolve(name:, email:, password:, role:)
      ActiveRecord::Base.transaction do
        user = User.new(name: name, email: email, password: password, role: role)

        if user.save
          begin
            token = JsonWebToken.encode(user_id: user.id)
            
            # 🔑 ADD THIS: Set HTTP-only cookie
            context[:response].set_cookie(
              :jwt,
              value: token,
              httponly: true,
              secure: Rails.env.production?,
              same_site: :lax,
              expires: 24.hours.from_now
            )
            
            Rails.logger.info "Cookie set for user #{user.id} with token: #{token[0..20]}..."
            
            { user: user, token: token, errors: [] }
          rescue => e
            Rails.logger.error "Token generation failed: #{e.message}"
            raise ActiveRecord::Rollback  # rollback user creation
          end
        else
          { user: nil, token: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end