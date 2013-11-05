FactoryGirl.define do

  factory :admin do
    sequence(:email)      { |n| "admin#{n}@domain.com" }
    password              'some_password'
    password_confirmation 'some_password'

    ignore do
      confirm_account true
    end

    after(:create) do |u, evaluator|
      u.confirm! if evaluator.confirm_account
    end

    trait :with_reset_password_token do
      reset_password_token { SecureRandom.hex }
    end

    trait :with_authentication_token do
      authentication_token { SecureRandom.hex }
    end
  end
end
