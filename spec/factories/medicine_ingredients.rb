# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine_ingredient do
    association :medicine
    association(:ingredient, :active)
    strength { 27.5 }
    uom { "mcg" }

    trait :active do
      active { true }
    end
  end
end
