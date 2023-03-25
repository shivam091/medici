# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateExpenses < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :expenses, id: :uuid do |t|
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_expenses_store_id_on_stores,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_expenses_user_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.string :reference_code
      t.string :criteria
      t.decimal :amount, precision: 8, scale: 2, default: 0.0
      t.enum :status, enum_type: :expense_statuses, default: "pending"

      t.not_null_and_empty_constraint :criteria
      t.not_null_and_empty_constraint :reference_code

      t.not_null_constraint :amount
      t.not_null_constraint :store_id
      t.not_null_constraint :user_id

      t.numericality_constraint :amount, greater_than: 0.0

      t.length_constraint :reference_code, less_than_or_equal_to: 15
      t.length_constraint :criteria, less_than_or_equal_to: 55

      t.timestamps_with_timezone null: false
    end
  end
end
