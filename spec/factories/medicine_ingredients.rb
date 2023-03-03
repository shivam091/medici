# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine_ingredient do
    association :medicine
    association(:ingredient, :active)
    active { true }
    strength { 27.5 }
    uom { "mcg" }
  end
end
