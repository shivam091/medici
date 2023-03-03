# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :supplier do
    name { "Supplier" }
    sequence(:email) { |n| "supplier#{n}@medici.com" }
    phone_number { "+911234567890" }
  end
end
