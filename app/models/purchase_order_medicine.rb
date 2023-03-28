# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderMedicine < ApplicationRecord
  attribute :quantity, default: 1
  attribute :cost, default: 0.0

  validates :medicine_id,
            presence: true,
            reduce: true
  validates :quantity,
            presence: true,
            numericality: {only_integer: true, greater_than: 0},
            reduce: true
  validates :cost,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true

  belongs_to :purchase_order, inverse_of: :purchase_order_medicines, touch: true
  belongs_to :medicine, inverse_of: :purchase_order_medicines

  before_create :add_quantity_to_replenishment
  before_update :update_quantity_of_replenishment
  before_destroy :subtract_quantity_from_replenishment

  delegate :name, to: :medicine, prefix: true

  private

  def add_quantity_to_replenishment
    replenishment = self.medicine.replenishment
    replenishment.lock!

    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier + self.quantity)
    )
  end

  def subtract_quantity_from_replenishment
    replenishment = self.medicine.replenishment
    replenishment.lock!

    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier - self.quantity)
    )
  end

  def update_quantity_of_replenishment
    replenishment = self.medicine.replenishment
    replenishment.lock!

    difference_in_quantity = quantity - quantity_was
    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier + difference_in_quantity)
    )
  end
end
