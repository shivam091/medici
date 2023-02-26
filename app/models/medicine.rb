# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicine < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  belongs_to :manufacturer, inverse_of: :medicines
  belongs_to :medicine_category, inverse_of: :medicines
  belongs_to :packing_type, inverse_of: :medicines
  belongs_to :dosage_form, inverse_of: :medicines

  default_scope -> { order(arel_table[:code].asc) }
end