# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Discount < ApplicationRecord
  validates :country_id,
            presence: true,
            uniqueness: {message: :already_has_discount},
            reduce: true
  validates :percent_off,
            presence: true,
            numericality: {greater_than_or_equal_to: 0.0},
            reduce: true

  belongs_to :country, inverse_of: :tax_rate

  delegate :name, to: :country, prefix: true

  default_scope do
    discounts_arel = ::Discount.arel_table
    countries_arel = ::Country.arel_table

    join = discounts_arel.join(countries_arel)
      .on(discounts_arel[:country_id].eq(countries_arel[:id]))
      .join_sources
    joins(join).order(countries_arel[:iso2].asc)
  end
end
