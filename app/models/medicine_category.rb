# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineCategory < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            length: {maximum: 55},
            uniqueness: true,
            reduce: true
  validates :description,
            length: {maximum: 255},
            allow_blank: true,
            allow_nil: true,
            reduce: true

  default_scope -> { order_name_asc }
end
