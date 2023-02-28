# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineSupplier < ApplicationRecord
  attribute :total_quantity_supplied, default: 0

  belongs_to :medicine, inverse_of: :medicine_suppliers, touch: true
  belongs_to :supplier, inverse_of: :medicine_suppliers

  delegate :name, :email, :phone_number, to: :supplier, prefix: true
end
