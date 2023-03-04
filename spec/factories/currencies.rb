# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :currency do
    name { "Indian rupee" }
    iso_code { "INR" }
    symbol { "₹" }
    subunit { "Paisa" }
    subunit_to_unit { 100 }
    symbol_first { true }
    decimal_mark { "." }
    thousands_separator { "," }
  end
end
