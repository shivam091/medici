# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currency < ApplicationRecord
  include Filterable

  attribute :is_active, default: false

  default_scope -> { order(arel_table[:iso_code].asc) }
end
