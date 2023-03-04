# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineSupplier < ApplicationRecord
  attribute :total_quantity_supplied, default: 0

  validates :medicine_id, :supplier_id, presence: true, reduce: true
  validates :total_quantity_supplied,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 0},
            reduce: true

  belongs_to :medicine, inverse_of: :medicine_suppliers, touch: true
  belongs_to :supplier, inverse_of: :medicine_suppliers

  delegate :name, :email, :phone_number, to: :supplier, prefix: true
  delegate :name, to: :medicine, prefix: true
end
