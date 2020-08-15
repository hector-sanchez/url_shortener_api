FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@email.com" }
    password_digest { BCrypt::Password.create("G00dP@ssw0rd") }
  end
end