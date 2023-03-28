# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  trait :active do
    is_active { true }
  end

  trait :with_address do
    after(:create) do |object|
      create(:address, addressable: object)
    end
  end

  trait :with_user do
    after(:build) do |object, evaluator|
      object.user = (::User.first || create(:manager, :confirmed, :active, :with_store))
    end
  end

  trait :with_store do
    after(:build) do |object, evaluator|
      object.store = (::Store.first || create(:store, :with_address, :active))
    end
  end

  trait :with_medicine do
    after(:build) do |object, evaluator|
      object.medicine = (::Medicine.first || create(:medicine, :with_suppliers, :with_ingredients, :with_user, :active))
    end
  end
end
