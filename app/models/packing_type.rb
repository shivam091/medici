# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PackingType < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true

  default_scope -> { order_name_asc }
end