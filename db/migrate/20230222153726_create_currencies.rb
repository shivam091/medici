# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCurrencies < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :currencies, id: :uuid do |t|
      t.string :name, index: {using: :btree, unique: true}
      t.string :iso_code, index: {using: :btree, unique: true}
      t.string :symbol
      t.string :subunit
      t.integer :subunit_to_unit
      t.boolean :symbol_first
      t.string :decimal_mark
      t.string :thousands_separator
      t.boolean :is_active, default: false, index: {using: :btree}

      t.length_constraint :name, less_than_or_equal_to: 55
      t.length_constraint :iso_code, equal_to: 3
      t.length_constraint :decimal_mark, equal_to: 1
      t.length_constraint :thousands_separator, equal_to: 1

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :iso_code
      t.not_null_and_empty_constraint :symbol
      t.not_null_and_empty_constraint :decimal_mark
      t.not_null_and_empty_constraint :thousands_separator

      t.uppercase_constraint :iso_code

      t.timestamps_with_timezone null: false
    end
  end
end
