# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateShifts < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :shifts, id: :uuid do |t|
      t.string :name, index: {using: :btree, unique: true}
      t.time :starts_at
      t.time :ends_at
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :name

      t.not_null_constraint :starts_at
      t.not_null_constraint :ends_at

      t.length_constraint :name, less_than_or_equal_to: 55

      t.timestamps_with_timezone null: false
    end
  end
end
