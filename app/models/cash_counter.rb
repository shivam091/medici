# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CashCounter < ApplicationRecord
  include Filterable, Sortable, Toggleable

  validates :identifier,
            presence: true,
            uniqueness: {scope: :store_id},
            length: {maximum: 55},
            reduce: true

  has_many :cash_counter_operators, dependent: :destroy
  has_many :operators, through: :cash_counter_operators, source: :user

  belongs_to :store, touch: true

  delegate :name, :phone_number, :email, to: :store

  accepts_nested_attributes_for :cash_counter_operators,
                                allow_destroy: true,
                                reject_if: :reject_cash_counter_operator?

  default_scope -> { order(arel_table[:identifier].asc) }

  private

  def reject_cash_counter_operator?(attributes)
    attributes[:user_id].blank? && attributes[:shift_id].blank?
  end
end
