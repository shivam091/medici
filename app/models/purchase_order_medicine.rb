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

  before_commit :update_replenishment

  delegate :name, to: :medicine, prefix: true

  private

  def update_replenishment
    replenishment = self.medicine.replenishment
    replenishment.lock!

    if self.previously_new_record?
      replenishment.update_column(
        :quantity_pending_from_supplier,
        (replenishment.quantity_pending_from_supplier + self.quantity)
      )
    elsif self.destroyed?
      replenishment.update_column(
        :quantity_pending_from_supplier,
        (replenishment.quantity_pending_from_supplier - self.quantity)
      )
    else
      difference_in_quantity = quantity - quantity_previously_was
      replenishment.update_column(
        :quantity_pending_from_supplier,
        (replenishment.quantity_pending_from_supplier + difference_in_quantity)
      )
    end
  end
end
