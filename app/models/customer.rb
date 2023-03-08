# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customer < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  default_scope -> { order(arel_table[:reference_code].asc) }
end
