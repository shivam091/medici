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
    password_automatically_set { false }

    factory :super_admin, parent: :user do
      email { "super_admin@medici.com" }
      mobile_number { generate(:mobile_number) }

      role { ::Role.find_by(name: "super_admin") || create(:super_admin_role, :active) }
    end

    factory :admin, parent: :user do
      email { "admin@medici.com" }
      mobile_number { generate(:mobile_number) }

      store { ::Store.first || create(:store, :with_address, :active) }
      role { ::Role.find_by(name: "admin") || create(:admin_role, :active) }
    end

    factory :manager, parent: :user do
      email { "manager@medici.com" }
      mobile_number { generate(:mobile_number) }

      store { ::Store.first || create(:store, :with_address, :active) }
      role { ::Role.find_by(name: "manager") || create(:manager_role, :active) }
    end

    factory :cashier, parent: :user do
      email { "cashier@medici.com" }
      mobile_number { generate(:mobile_number) }

      store { ::Store.first || create(:store, :with_address, :active) }
      role { ::Role.find_by(name: "cashier") || create(:cashier_role, :active) }
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
