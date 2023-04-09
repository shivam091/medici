# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrder < ApplicationRecord
  include Sortable, ReferenceCode, AASM

  enum status: {
    pending: "pending",
    incomplete: "incomplete",
    received: "received"
  }

  attribute :status, :enum, default: statuses[:pending]

  aasm :purchase_order_status, column: "status", enum: true do
    state :pending, initial: true
    state :incomplete, :received

    event :mark_as_incomplete do
      transitions from: :pending, to: :incomplete
    end

    event :mark_as_received, after: [:receive_medicines] do
      transitions from: [:pending, :incomplete], to: :received
    end
  end

  validates :reference_code,
            uniqueness: true,
            length: {maximum: 15},
            reduce: true
  validates :invoice_number,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :supplier_id,
            presence: true,
            reduce: true
  validates :tracking_number,
            length: {maximum: 55},
            allow_blank: true,
            allow_nil: true
  validates :status,
            presence: true,
            inclusion: {in: statuses.values},
            reduce: true
  validates :ordered_at,
            presence: true,
            comparison: {less_than_or_equal_to: Date.today},
            reduce: true
  validates :expected_arrival_at,
            comparison: {greater_than_or_equal_to: Date.today},
            allow_nil: true,
            reduce: true
  validates :store_id, presence: true, reduce: true

  has_many :purchase_order_items, dependent: :destroy
  has_many :medicines,
           through: :purchase_order_items,
           source: :medicine,
           inverse_of: :purchase_order_items

  belongs_to :store, inverse_of: :purchase_orders, optional: true
  belongs_to :supplier, inverse_of: :purchase_orders
  belongs_to :user, inverse_of: :purchase_orders

  before_validation :set_store
  after_commit :broadcast_purchase_orders_count, on: [:create, :destroy]

  delegate :name, to: :store, prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :supplier, prefix: true

  accepts_nested_attributes_for :purchase_order_items,
                                allow_destroy: true,
                                reject_if: :reject_purchase_order_item?

  default_scope -> { order_reference_code_asc }

  class << self
    def accessible(user)
      if user.admin?
        all
      elsif user.manager?
        user.store.purchase_orders
      else
        none
      end
    end

    def today
      where(
        ::Medici::SQL::Functions.date(::PurchaseOrder[:created_at]).eq(Date.current)
      )
    end

    def this_month
      where(
        ::Medici::SQL::Functions.date(::PurchaseOrder[:created_at]).between(Date.current.all_month)
      )
    end

    def total_cost
      all.extract_associated(:purchase_order_items).flatten.sum(&:cost)
    end
  end

  def total_cost
    purchase_order_items.sum(&:cost)
  end

  private

  def receive_medicines
    purchase_order_items.each do |purchase_order_item|
      purchase_order_item.receive!
    end
  end

  def reject_purchase_order_item?(attributes)
    [
      attributes[:medicine_id],
      attributes[:quantity],
      attributes[:cost]
    ].any?(&:blank?)
  end

  def set_store
    if (store.nil? && user.present?)
      self.store = self.user.store
    end
  end

  def broadcast_purchase_orders_count
    broadcast_update_to(:purchase_orders, target: :purchase_orders_count, html: ::PurchaseOrder.count)
  end
end
