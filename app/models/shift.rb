# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shift < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :starts_at, :ends_at,
            presence: true,
            reduce: true

  has_many :cash_counter_operators, dependent: :restrict_with_exception

  default_scope -> { order_name_asc }
end
