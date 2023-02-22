# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Address < ApplicationRecord
  include Sortable

  belongs_to :addressable, polymorphic: true, optional: true
  belongs_to :country, inverse_of: :addresses

  delegate :name, :iso2, :iso3, to: :country, prefix: true

  default_scope -> { order_created_desc }
end
