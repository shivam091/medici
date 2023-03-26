# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Country < ApplicationRecord
  include Filterable, Toggleable

  attribute :has_postal_code, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :iso2,
            presence: true,
            length: {is: 2},
            uniqueness: true,
            uppercase: true,
            reduce: true
  validates :iso3,
            presence: true,
            length: {is: 3},
            uniqueness: true,
            uppercase: true,
            reduce: true
  validates :calling_code,
            presence: true,
            length: {in: 2..10},
            format: {with: /\A[\+{1}]+[\d]*\z/},
            reduce: true
  validates :currency_id, presence: true, reduce: true

  has_one :tax_rate, dependent: :restrict_with_exception
  has_one :discount, dependent: :restrict_with_exception

  has_many :addresses, dependent: :restrict_with_exception

  belongs_to :currency, inverse_of: :countries

  delegate :name, :iso_code, :symbol, to: :currency, prefix: true

  default_scope -> { order(arel_table[:iso2].asc) }

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
