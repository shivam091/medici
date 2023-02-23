# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currency < ApplicationRecord
  include Filterable

  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :iso_code,
            presence: true,
            uniqueness: true,
            uppercase: true,
            length: {is: 3},
            reduce: true
  validates :symbol,
            presence: true,
            reduce: true
  validates :subunit_to_unit,
            presence: true,
            numericality: {only_integer: true},
            length: {maximum: 5},
            reduce: true
  validates :thousands_separator, :decimal_mark,
            presence: true,
            inclusion: {in: %w(. ,)},
            length: {is: 1},
            reduce: true

  has_many :countries, dependent: :nullify

  default_scope -> { order(arel_table[:iso_code].asc) }
end
