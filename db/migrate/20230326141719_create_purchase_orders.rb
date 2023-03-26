# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreatePurchaseOrders < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :purchase_orders, id: :uuid do |t|
      t.string :reference_code, index: {using: :btree, unique: true}
      t.string :invoice_number, index: {using: :btree, unique: true}
      t.string :tracking_number
      t.date :ordered_at
      t.date :expected_arrival_at
      t.enum :status, enum_type: :purchase_order_statuses, default: "pending"
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_purchase_orders_user_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.references :supplier,
                   type: :uuid,
                   foreign_key: {
                     to_table: :suppliers,
                     name: :fk_purchase_orders_supplier_id_on_suppliers,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_purchase_orders_store_id_on_stores,
                     on_delete: :restrict
                   },
                   index: {using: :btree}

      t.not_null_constraint :supplier_id
      t.not_null_constraint :store_id
      t.not_null_constraint :user_id
      t.not_null_constraint :ordered_at

      t.not_null_and_empty_constraint :invoice_number

      t.length_constraint :reference_code, less_than_or_equal_to: 15
      t.length_constraint :invoice_number, less_than_or_equal_to: 55
      t.length_constraint :tracking_number, less_than_or_equal_to: 55

      t.inclusion_constraint :status, in: ["pending", "incomplete", "received"]

      t.check_constraint "ordered_at <= CURRENT_DATE", name: "ordered_at_lteq_today"
      t.check_constraint "expected_arrival_at >= CURRENT_DATE", name: "expected_arrival_at_gteq_today"

      t.timestamps_with_timezone null: false
    end
  end
end
