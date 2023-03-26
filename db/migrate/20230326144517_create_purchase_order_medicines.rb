# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreatePurchaseOrderMedicines < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :purchase_order_medicines, id: :uuid do |t|
      t.references :purchase_order,
                   type: :uuid,
                   foreign_key: {
                     to_table: :purchase_orders,
                     name: :fk_purchase_order_medicines_purchase_order_id_on_purchase_orders,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :medicine,
                   type: :uuid,
                   foreign_key: {
                     to_table: :medicines,
                     name: :fk_purchase_order_medicines_medicine_id_on_medicines,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.integer :quantity, default: 1
      t.decimal :cost, precision: 8, scale: 2, default: 0.0
      t.boolean :is_received, default: false

      t.not_null_constraint :quantity
      t.not_null_constraint :cost
      t.not_null_constraint :purchase_order_id
      t.not_null_constraint :medicine_id

      t.numericality_constraint :quantity, greater_than: 0
      t.numericality_constraint :cost, greater_than: 0.0

      t.timestamps_with_timezone null: false
    end
  end
end
