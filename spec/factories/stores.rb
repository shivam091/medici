# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :store do
    factory :main_store, parent: :store do
      name { "Pharmacy store" }
      email { "pharmacy_store@medici.com" }
      phone_number { "+911234567890" }
      fax_number { "+911234567890" }
      registration_number { "1234567890" }
      is_main_store { true }

      trait :with_manager do
        after(:create) do |store|
          store.users << create(:main_store_manager, :confirmed, :active)
        end
      end

      trait :with_cashier do
        after(:create) do |store|
          store.users << create(:main_store_cashier, :confirmed, :active)
        end
      end
    end

    factory :mini_store, parent: :store do
      name { "Pharmacy mini store" }
      email { "pharmacy_mini_store@medici.com" }
      phone_number { "+910987654321" }
      fax_number { "+910987654321" }
      registration_number { "0987654321" }

      trait :with_manager do
        after(:create) do |store|
          store.users << create(:mini_store_manager, :confirmed, :active)
        end
      end

      trait :with_cashier do
        after(:create) do |store|
          store.users << create(:mini_store_cashier, :confirmed, :active)
        end
      end
    end

    trait :active do
      is_active { true }
    end
  end
end
