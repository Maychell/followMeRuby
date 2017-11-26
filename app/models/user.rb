class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info

    User.first_or_create(name: data['name'],
      email: data['email'],
      password: Devise.friendly_token[0,20]
    )
  end
end
