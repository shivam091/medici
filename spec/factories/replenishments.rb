# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :replenishment do
    quantity_pending_from_supplier { 0 }
    medicine { create(:medicine, :active) }
  end
end
