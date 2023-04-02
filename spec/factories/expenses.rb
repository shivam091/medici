# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :expense do
    criteria { "Salary" }
    amount { "20000" }
  end
end
