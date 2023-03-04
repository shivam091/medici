# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine_supplier do
    association :medicine
    association(:supplier, :with_address, :active)
  end
end
