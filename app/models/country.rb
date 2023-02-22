# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Country < ApplicationRecord
  include Filterable

  attribute :is_active, default: false
  attribute :has_postal_code, default: false

  has_many :addresses, dependent: :restrict_with_exception

  belongs_to :currency, inverse_of: :countries

  delegate :name, :iso_code, :symbol, to: :currency, prefix: true

  default_scope -> { order(arel_table[:iso2].asc) }
end
