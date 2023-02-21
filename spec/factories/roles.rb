# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :role do
    factory :admin_role, parent: :role do
      name { "admin" }
    end

    trait :active do
      is_active { true }
    end
  end
end
