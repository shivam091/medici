# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :user do
    first_name { "Harshal" }
    last_name { "Ladhe" }
    password { Rails.application.credentials.config[:TEST_PASSWORD] }
    password_confirmation { Rails.application.credentials.config[:TEST_PASSWORD] }

    factory :admin, parent: :user do
      email { "admin@medici.com" }
      mobile_number { "+919136558669" }

      association :role, factory: :admin_role
    end

    trait :active do
      is_active { true }
    end

    trait :confirmed do
      unconfirmed_email { "" }
      confirmation_token { "" }
      confirmed_at { DateTime.current }
      confirmation_sent_at { nil }
    end

    trait :banned do
      is_banned { true }
    end
  end
end
