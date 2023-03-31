# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxRate < ApplicationRecord

  self.inheritance_column = :_type_disabled

  enum type: {
    vat: "vat",
    gst: "gst",
    cgst: "cgst",
    sgst: "sgst",
    pst: "pst",
    hst: "hst",
    st: "st",
  }

  validates :country_id,
            presence: true,
            uniqueness: {message: :already_has_tax_rate},
            reduce: true
  validates :rate,
            presence: true,
            numericality: {greater_than_or_equal_to: 0.0},
            reduce: true
  validates :type, presence: true, inclusion: {in: types.values}, reduce: true

  belongs_to :country, inverse_of: :tax_rate

  delegate :name, to: :country, prefix: true

  default_scope do
    tax_rates_arel = ::TaxRate.arel_table
    countries_arel = ::Country.arel_table

    join = tax_rates_arel.join(countries_arel)
      .on(tax_rates_arel[:country_id].eq(countries_arel[:id]))
      .join_sources
    joins(join).order(countries_arel[:iso2].asc)
  end
end
