# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customer < ApplicationRecord
  include Filterable, Sortable, ReferenceCode

  attribute :is_active, default: false

  validates :reference_code,
            length: {maximum: 15},
            reduce: true
  validates :name,
            presence: true,
            length: {maximum: 110},
            reduce: true
  validates :email,
            uniqueness: true,
            length: {maximum: 55},
            email: true,
            allow_blank: true,
            allow_nil: true,
            reduce: true
  validates :mobile_number,
            presence: true,
            uniqueness: true,
            length: {maximum: 32},
            reduce: true

  has_one :address, as: :addressable, dependent: :destroy

  delegate :country, to: :address
  delegate :name, to: :country, prefix: true

  accepts_nested_attributes_for :address, update_only: true

  default_scope -> { order(arel_table[:reference_code].asc) }

  def address
    super.presence || build_address
  end
end
