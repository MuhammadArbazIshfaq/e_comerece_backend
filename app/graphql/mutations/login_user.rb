# app/graphql/mutations/login_user.rb (similar for signup_user.rb)
module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user && user.authenticate(password)
        token = JsonWebToken.encode(user_id: user.id)

        # Set HTTP-only cookie
        context[:response].set_cookie(
          :jwt,
          value: token,
          httponly: true,
          secure: Rails.env.production?, # only send via HTTPS in production
          same_site: :lax, # or :strict if you want tighter CSRF protection
          expires: 24.hours.from_now
        )

        { user: user, errors: [] }
      else
        { user: nil, errors: ["Invalid credentials"] }
      end
    end
  end
end
