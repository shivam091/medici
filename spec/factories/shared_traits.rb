# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  trait :active do
    is_active { true }
  end

  trait :with_address do
    after(:build) do |object|
      object.address = create(:address, addressable: object)
    end
  end
end
