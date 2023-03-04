# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :country do
    name { "India" }
    iso2 { "IN" }
    iso3 { "IND" }
    calling_code { "+91" }
    currency { ::Currency.first || association(:currency, :active) }

    trait :with_currency do
      after(:build) do |country|
        country.currency = create(:currency, :active)
      end
    end
  end
end
