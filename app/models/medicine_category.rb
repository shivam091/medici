# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineCategory < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  default_scope -> { order_name_asc }
end
