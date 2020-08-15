FactoryBot.define do
  factory :short_url do
    slug { FFaker::Internet.slug }
    expire_at { 5.days.from_now }
    original_url { FFaker::Internet.http_url }

    trait :expired do
      expire_at { 1.day.ago }
    end

    trait :with_user do
      user
    end
  end
end
