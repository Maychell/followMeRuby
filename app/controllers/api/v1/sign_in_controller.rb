class Api::V1::SignInController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate, only: :create

  def create
    validator = GoogleIDToken::Validator.new

    begin
      payload = validator.check(params['id_token'], ENV['GOOGLE_CLIENT_ID'])

      @user = User.find_or_create_by(email: payload['email']) do |user|
        user.name      = payload['name']
        user.image_url = payload['picture']
        user.password  = Devise.friendly_token[0,20]
      end

      render json: @user, status: :success
    rescue GoogleIDToken::ValidationError => e
      render json: { error: 'Login com Google não autorizado' }, status: :unauthorized
    end
  end
end
