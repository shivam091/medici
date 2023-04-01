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

  delegate :full_name, to: :user, prefix: true
  delegate :name, :starts_at, :ends_at, to: :shift, prefix: true

  scope :including_users_and_shifts, -> { includes(:shift, :user) }
  default_scope -> { order_created_desc }
end
