# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :address do
    address1 { "New Panvel (E)" }
    city { "Navi Mumbai" }
    region { "Maharashtra" }
    postal_code { "410206" }
    country { ::Country.first || create(:country, :active) }
    association :addressable
  end
end
