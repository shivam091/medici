# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :user do
    first_name { "Harshal" }
    last_name { "Ladhe" }
    password { Rails.application.credentials.config[:TEST_PASSWORD] }
    password_confirmation { Rails.application.credentials.config[:TEST_PASSWORD] }
    last_password_updated_at { DateTime.now }
    password_expires_at { ::User::DEFAULT_PASSWORD_EXPIRY_PERIOD }
    password_automatically_set { true }

    factory :admin, parent: :user do
      email { "admin@medici.com" }
      mobile_number { "+919136558669" }

      store { ::Store.first || association(:store, :with_address) }
      role { ::Role.find_by(name: "admin") || association(:admin_role, :active) }
    end

    factory :manager, parent: :user do
      email { "manager@medici.com" }
      mobile_number { "+911234567890" }

      store { ::Store.first || association(:store, :with_address) }
      role { ::Role.find_by(name: "manager") || association(:manager_role, :active) }
    end

    factory :cashier, parent: :user do
      email { "cashier@medici.com" }
      mobile_number { "+918879001262" }

      store { ::Store.first || association(:store, :with_address) }
      role { ::Role.find_by(name: "cashier") || association(:cashier_role, :active) }
    end

    trait :with_address do
      after(:build) do |user|
        user.address = create(:address, addressable: user)
      end
    end

    trait :active do
      is_active { true }
    end

    trait :confirmed do
      unconfirmed_email { "" }
      confirmation_token { nil }
      confirmed_at { DateTime.current }
      confirmation_sent_at { nil }
    end

    trait :banned do
      is_banned { true }
    end
  end
end
