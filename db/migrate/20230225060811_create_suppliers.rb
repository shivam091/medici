# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateSuppliers < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :suppliers, id: :uuid do |t|
      t.string :name
      t.string :email, index: {using: :btree, unique: true}
      t.string :phone_number, index: {using: :btree, unique: true}
      t.boolean :is_active, default: false

      t.timestamps_with_timezone null: false
    end
  end
end
