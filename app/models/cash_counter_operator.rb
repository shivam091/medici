# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CashCounterOperator < ApplicationRecord
  include Filterable, Sortable

  validates :user_id,
            :shift_id,
            presence: true,
            reduce: true

  belongs_to :user
  belongs_to :cash_counter, touch: true
  belongs_to :shift

  default_scope -> { order_created_desc }
end
