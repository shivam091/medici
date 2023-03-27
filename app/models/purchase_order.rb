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

    event :mark_as_received do
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

  has_many :purchase_order_medicines, dependent: :destroy
  has_many :medicines,
           through: :purchase_order_medicines,
           source: :medicine,
           inverse_of: :purchase_order_medicines

  belongs_to :store, inverse_of: :purchase_orders
  belongs_to :supplier, inverse_of: :purchase_orders
  belongs_to :user, inverse_of: :purchase_orders

  delegate :name, to: :store, prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :supplier, prefix: true

  accepts_nested_attributes_for :purchase_order_medicines,
                                allow_destroy: true,
                                reject_if: :reject_purchase_order_medicine?

  default_scope -> { order_reference_code_asc }

  private

  def reject_purchase_order_medicine?(attributes)
    [
      attributes[:medicine_id],
      attributes[:quantity],
      attributes[:cost]
    ].all?(&:blank?)
  end
end
