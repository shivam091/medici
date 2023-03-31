# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Store < ApplicationRecord
  include Filterable, Sortable, ReferenceCode, Toggleable

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
            uniqueness: true,
            reduce: true
  validates :currency_id,
            presence: true,
            reduce: true

  has_one :address, as: :addressable, dependent: :destroy

  has_many :users, dependent: :destroy
  has_many :cash_counters, dependent: :destroy
  has_many :purchase_orders, dependent: :restrict_with_exception
  has_many :expenses, dependent: :destroy
  has_many :medicines, dependent: :destroy
  has_many :medicine_suppliers, dependent: :destroy
  has_many :suppliers,
           through: :medicine_suppliers,
           source: :supplier,
           inverse_of: :medicine_suppliers

  belongs_to :currency

  delegate :country, to: :address
  delegate :name, to: :country, prefix: true, allow_nil: true
  delegate :name, :symbol, to: :currency, prefix: true, allow_nil: true

  after_commit :broadcast_active_stores_count, on: [:create, :destroy]
  after_commit on: :update do
    broadcast_active_stores_count if is_active_previously_changed?
  end

  accepts_nested_attributes_for :address, update_only: true
  accepts_nested_attributes_for :cash_counters,
                                allow_destroy: true,
                                reject_if: :reject_cash_counter?

  default_scope -> { order_reference_code_asc }

  def address
    super.presence || build_address
  end

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end

  private

  def broadcast_active_stores_count
    broadcast_update_to(
      :stores,
      target: :active_stores_count,
      html: ::Store.active.count
    )
  end

  def reject_cash_counter?(attributes)
    attributes["identifier"].blank?
  end
end
