# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateIngredients < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :ingredients, id: :uuid do |t|
      t.string :reference_code, index: {using: :btree, unique: true}
      t.string :name, index: {using: :btree, unique: true}
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :reference_code
      t.not_null_and_empty_constraint :name

      t.length_constraint :reference_code, less_than_or_equal_to: 15
      t.length_constraint :name, less_than_or_equal_to: 55

      t.timestamps_with_timezone null: false
    end
  end
end
