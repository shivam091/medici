# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :manufacturer do
    name { "Manufacturer" }
    email { generate(:email) }
    phone_number { generate(:phone_number) }
  end
end
