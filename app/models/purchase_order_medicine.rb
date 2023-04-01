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

  after_save :update_po_status, if: :is_received_previously_changed?
  after_create :add_quantity_pending_from_supplier
  before_update :update_quantity_pending_from_supplier, if: :quantity_changed?
  after_destroy :subtract_quantity_pending_from_supplier

  delegate :name, to: :medicine, prefix: true

  scope :received, -> { where(::PurchaseOrderMedicine[:is_received].eq(true)) }

  def receive!
    ::PurchaseOrderMedicine.transaction do
      if self.update_column(:is_received, true)
        update_stock
        update_replenishment
        update_total_supplied_quantity
      end
    end
  end

  private

  def update_stock
    stock = self.medicine.stock
    stock.lock!
    stock.update_column(:quantity_in_hand, (stock.quantity_in_hand + self.quantity))
  end

  def update_replenishment
    replenishment = self.medicine.replenishment
    replenishment.lock!

    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier - self.quantity)
    )
  end

  def update_total_supplied_quantity
    supplier = purchase_order.supplier
    medicine_supplier = self.medicine.medicine_suppliers.find_by(supplier_id: supplier.id)
    medicine_supplier.lock!
    medicine_supplier.update(
      total_quantity_supplied: (medicine_supplier.total_quantity_supplied + self.quantity)
    )
  end

  def update_po_status
    po_medicines = purchase_order.purchase_order_medicines

    if po_medicines.received.size == po_medicines.size
      purchase_order.mark_as_received!
    elsif is_received? && !purchase_order.incomplete?
      purchase_order.mark_as_incomplete!
    end
  end

  def add_quantity_pending_from_supplier
    replenishment = self.medicine.replenishment
    replenishment.lock!

    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier + self.quantity)
    )
  end

  def update_quantity_pending_from_supplier
    replenishment = self.medicine.replenishment
    replenishment.lock!

    difference_in_quantity = quantity - quantity_was
    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier + difference_in_quantity)
    )
  end

  def subtract_quantity_pending_from_supplier
    replenishment = self.medicine.replenishment
    replenishment.lock!

    replenishment.update_column(
      :quantity_pending_from_supplier,
      (replenishment.quantity_pending_from_supplier - self.quantity)
    )
  end
end
