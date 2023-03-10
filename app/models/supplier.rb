# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Supplier < ApplicationRecord
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
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            email: true,
            reduce: true
  validates :phone_number,
            presence: true,
            uniqueness: true,
            length: {maximum: 32},
            reduce: true

  has_one :address, as: :addressable, dependent: :destroy

  has_many :medicine_suppliers, dependent: :restrict_with_exception
  has_many :medicines,
           through: :medicine_suppliers,
           source: :medicine,
           inverse_of: :medicine_suppliers

  delegate :country, to: :address
  delegate :name, to: :country, prefix: true

  accepts_nested_attributes_for :address, update_only: true

  default_scope -> { order_reference_code_asc }

  def address
    super.presence || build_address
  end

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
