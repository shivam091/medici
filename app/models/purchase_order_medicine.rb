# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderMedicine < ApplicationRecord
  attribute :quantity, default: 1
  attribute :cost, default: 0.0

  validates :medicine_id,
            presence: true,
            reduce: true
  validates :quantity,
            presence: true,
            numericality: {only_integer: true, greater_than: 0},
            reduce: true
  validates :cost,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true

  belongs_to :purchase_order, inverse_of: :purchase_order_medicines, touch: true
  belongs_to :medicine, inverse_of: :purchase_order_medicines

  delegate :name, to: :medicine, prefix: true
end
