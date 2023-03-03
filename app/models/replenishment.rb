# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Replenishment < ApplicationRecord
  self.primary_key = :medicine_id

  attribute :quantity_pending_from_supplier, default: 0

  validates :medicine_id, presence: true, reduce: true
  validates :quantity_pending_from_supplier,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 0},
            reduce: true

  belongs_to :medicine, inverse_of: :replenishment, touch: true
end
