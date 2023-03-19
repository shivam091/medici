# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :shift do
    name { "Morning" }
    starts_at { "10:00" }
    ends_at { "17:00" }
  end
end
