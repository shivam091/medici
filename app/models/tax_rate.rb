# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxRate < ApplicationRecord

  self.inheritance_column = :_type_disabled

  belongs_to :country

  default_scope do
    tax_rates_arel = ::TaxRate.arel_table
    countries_arel = ::Country.arel_table

    join = tax_rates_arel.join(countries_arel)
      .on(tax_rates_arel[:country_id].eq(countries_arel[:id]))
      .join_sources
    joins(join).order(countries_arel[:iso2].asc)
  end
end
