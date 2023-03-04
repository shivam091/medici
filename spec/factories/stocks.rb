# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :stock do
    quantity_in_hand { 0 }
    medicine { create(:medicine, :active) }
  end
end
