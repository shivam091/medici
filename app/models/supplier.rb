# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Supplier < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  has_one :address, as: :addressable

  default_scope -> { order_name_asc }
end
