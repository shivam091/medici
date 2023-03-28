# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateReplenishments < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :replenishments, id: false do |t|
      t.references :medicine,
                   type: :uuid,
                   foreign_key: {
                     to_table: :medicines,
                     name: :fk_replenishments_medicine_id_on_medicines,
                     on_delete: :cascade
                   },
                   primary_key: true,
                   index: {using: :btree, unique: true}
      t.integer :quantity_pending_from_supplier, default: 0

      t.not_null_constraint :quantity_pending_from_supplier
      t.not_null_constraint :medicine_id

      t.numericality_constraint :quantity_pending_from_supplier, greater_than_or_equal_to: 0

      t.timestamps_with_timezone null: false
    end
  end
end
