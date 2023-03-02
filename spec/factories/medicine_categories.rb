# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine_category do
    name { "Antineoplastics" }
    description { "Drugs used to treat cancer." }
  end
end
