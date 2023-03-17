# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CashCounter < ApplicationRecord
  include Filterable, Sortable

  attribute :is_active, default: false

  validates :identifier,
            presence: true,
            uniqueness: {scope: :store_id},
            length: {maximum: 55},
            reduce: true
  validates :store_id, presence: true, reduce: true

  belongs_to :store

  delegate :name, :phone_number, :email, to: :store

  default_scope -> { order(arel_table[:identifier].asc) }
end
