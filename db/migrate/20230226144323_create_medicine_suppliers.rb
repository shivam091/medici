# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateMedicineSuppliers < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :medicine_suppliers, id: :uuid do |t|
      t.references :medicine,
                   type: :uuid,
                   foreign_key: {
                     to_table: :medicines,
                     name: :fk_medicine_suppliers_medicine_id_on_medicines,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :supplier,
                   type: :uuid,
                   foreign_key: {
                     to_table: :suppliers,
                     name: :fk_medicine_suppliers_supplier_id_on_suppliers,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_medicine_suppliers_store_id_on_stores,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.integer :total_quantity_supplied, default: 0

      t.not_null_constraint :medicine_id
      t.not_null_constraint :store_id
      t.not_null_constraint :supplier_id
      t.not_null_constraint :total_quantity_supplied

      t.numericality_constraint :total_quantity_supplied, greater_than_or_equal_to: 0

      t.timestamps_with_timezone null: false
    end
  end
end
