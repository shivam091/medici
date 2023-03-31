# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customer < ApplicationRecord
  include Filterable, Sortable, ReferenceCode, Toggleable

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

  after_commit :broadcast_active_customers_count, on: [:create, :destroy]
  after_commit on: :update do
    broadcast_active_customers_count if is_active_previously_changed?
  end

  accepts_nested_attributes_for :address, update_only: true

  scope :including_address, -> { includes(:address) }
  default_scope -> { order_reference_code_asc }

  def address
    super.presence || build_address
  end

  private

  def broadcast_active_customers_count
    broadcast_update_to(
      :customers,
      target: :active_customers_count,
      html: ::Customer.active.count
    )
  end
end
