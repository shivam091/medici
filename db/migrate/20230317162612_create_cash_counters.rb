# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCashCounters < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :cash_counters, id: :uuid do |t|
      t.string :identifier
      t.boolean :is_active, default: false
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_cash_counters_store_id_on_stores,
                     on_delete: :cascade
                   },
                   index: {using: :btree, unique: true}

      t.index [:identifier, :store_id], using: :btree, unique: true

      t.not_null_and_empty_constraint :identifier

      t.length_constraint :identifier, less_than_or_equal_to: 55

      t.timestamps_with_timezone null: false
    end
  end
end
