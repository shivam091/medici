# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currency < ApplicationRecord
  include Filterable, Toggleable

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :iso_code,
            presence: true,
            length: {is: 3},
            uniqueness: true,
            uppercase: true,
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
  has_many :stores, dependent: :restrict_with_exception

  default_scope -> { order(::Currency[:iso_code].asc) }

  class << self
    def select_options
      active.collect do |currency|
        ["#{currency.name} (#{currency.symbol})", currency.id]
      end
    end
  end
end
