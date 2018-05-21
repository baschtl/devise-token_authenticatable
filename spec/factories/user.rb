FactoryGirl.define do

  factory :user do
    username              'testuser'
    sequence(:email)      { |n| "user#{n}@domain.com" }
    password              'some_password'
    password_confirmation 'some_password'
    facebook_token        { SecureRandom.hex }

    ignore do
      confirm_account true
    end

    after(:create) do |u, evaluator|
      u.confirm if evaluator.confirm_account
    end

    trait :with_reset_password_token do
      reset_password_token { SecureRandom.hex }
    end

    trait :with_authentication_token do
      authentication_token { SecureRandom.hex }
      authentication_token_created_at { Time.now }
    end

    trait :with_day_old_token do
      authentication_token { SecureRandom.hex }
      authentication_token_created_at { Time.now - 1.day }
    end

    trait :without_created_at do
      authentication_token { SecureRandom.hex }
      authentication_token_created_at nil
    end
  end
end
