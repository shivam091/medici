# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :customer do
    name { "Customer" }
    sequence(:email) { |n| "customer#{n}@medici.com" }
    mobile_number { generate(:mobile_number) }
  end
end
