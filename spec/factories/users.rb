FactoryBot.define do
  factory :user do
    name "Foo Bar"
    sequence(:email) { |n| "foo_bar#{n}@example.com" }
    password Devise.friendly_token[0,20]
  end
end