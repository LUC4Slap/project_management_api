class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = extract_token_from_header
    # debugger
    decoded_token = decode_token(token)
    @current_user = find_user_from_token(decoded_token)
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end

  def decode_token(token)
    return nil unless token

    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }).first
    # debugger
    unless decoded_token['exp']
      raise JWT::ExpiredSignature, 'Token expirado'
    end
    # Verificar se o token expirou
    if decoded_token['exp'] != nil && decoded_token['exp'] < Time.now.to_i
      raise JWT::ExpiredSignature, 'Token expirado'
    end

    decoded_token.with_indifferent_access
  end

  def find_user_from_token(decoded_token)
    return nil unless decoded_token

    User.find(decoded_token[:user_id])
  end
end
