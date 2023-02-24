# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :store do
    name { "Pharmacy" }
    email { "pharmacy@example.com" }
    phone_number { "+911234567890" }
    fax_number { "+911234567890" }
    registration_number { "1234567890" }

    trait :with_manager do
      after(:create) do |store|
        store.users << create(:manager, :confirmed, :active)
      end
    end

    trait :with_cashier do
      after(:create) do |store|
        store.users << create(:cashier, :confirmed, :active)
      end
    end

    trait :active do
      is_active { true }
    end
  end
end
