# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Store < ApplicationRecord
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
  validates :registration_number,
            presence: true,
            reduce: true
  validates :currency_id,
            presence: true,
            reduce: true

  has_one :address, as: :addressable, dependent: :destroy

  has_many :users, dependent: :destroy

  belongs_to :currency

  delegate :country, to: :address
  delegate :name, to: :country, prefix: true, allow_nil: true
  delegate :name, :iso_code, to: :currency, prefix: true, allow_nil: true

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
