# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCashCounterOperators < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :cash_counter_operators, id: :uuid do |t|
      t.references :cash_counter,
                   type: :uuid,
                   foreign_key: {
                     to_table: :cash_counters,
                     name: :fk_cash_counter_operators_cash_counter_id_on_cash_counters,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
       t.references :shift,
                    type: :uuid,
                    foreign_key: {
                      to_table: :shifts,
                      name: :fk_cash_counter_operators_shift_id_on_shifts,
                      on_delete: :restrict
                    },
                    index: {using: :btree}
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_cash_counter_operators_user_id_on_users,
                     on_delete: :restrict
                   },
                   index: {using: :btree}

      t.timestamps_with_timezone null: false
    end
  end
end
