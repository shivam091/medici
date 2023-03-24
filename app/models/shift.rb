# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shift < ApplicationRecord
  include Filterable, Sortable, Toggleable

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

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
