class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  before_create :set_auth_token

  def self.from_omniauth(access_token)
    data = access_token.info

    User.first_or_create(name: data['name'],
      email: data['email'],
      password: Devise.friendly_token[0,20]
    )
  end

  private

  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end
end
