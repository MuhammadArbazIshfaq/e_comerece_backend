# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
      response: response  # expose Rails response to mutations
    }
    result = EcommerceBackendSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

def current_user
  # Use request.cookies here
  token = request.cookies['jwt'] || request.headers['Authorization']
  Rails.logger.info "AUTH HEADER: #{request.headers['Authorization']}"
  Rails.logger.info "COOKIE JWT: #{request.cookies['jwt']}"

  return nil unless token

  # Handle both "Bearer <token>" and raw "<token>"
  token = token.split(' ').last if token.include?(' ')

  Rails.logger.info "USING TOKEN: #{token}"

  decoded = JsonWebToken.decode(token)
  Rails.logger.info "DECODED PAYLOAD: #{decoded.inspect}"

  User.find_by(id: decoded[:user_id]) if decoded
rescue => e
  Rails.logger.error "CURRENT_USER ERROR: #{e.message}"
  nil
end



end
