# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :store do
    name { "Pharmacy store" }
    email { "store@medici.com" }
    phone_number { generate(:phone_number) }
    fax_number { generate(:phone_number) }
    registration_number { "1234567890" }

    trait :with_admin do
      after(:create) do |store|
        store.users << create(:admin, :confirmed, :active, :with_address)
      end
    end

    trait :with_manager do
      after(:create) do |store|
        store.users << create(:manager, :confirmed, :active, :with_address)
      end
    end

    trait :with_cashier do
      after(:create) do |store|
        store.users << create(:cashier, :confirmed, :active, :with_address)
      end
    end
  end

  trait :main_store do
    is_main_store { true }
  end
end
