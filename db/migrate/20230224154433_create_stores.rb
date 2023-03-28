# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateStores < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :stores, id: :uuid do |t|
      t.string :reference_code
      t.string :name
      t.string :email, index: {using: :btree, unique: true}
      t.string :phone_number, index: {using: :btree, unique: true}
      t.string :fax_number
      t.boolean :is_active, default: false
      t.string :registration_number, index: {using: :btree, unique: true}
      t.references :currency,
                   type: :uuid,
                   foreign_key: {
                     to_table: :currencies,
                     name: :fk_stores_currency_id_on_currencies,
                     on_delete: :restrict
                   },
                   index: {using: :btree}

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :email
      t.not_null_and_empty_constraint :phone_number
      t.not_null_and_empty_constraint :registration_number
      t.not_null_and_empty_constraint :reference_code

      t.length_constraint :email, less_than_or_equal_to: 55
      t.length_constraint :phone_number, less_than_or_equal_to: 32
      t.length_constraint :fax_number, less_than_or_equal_to: 32
      t.length_constraint :reference_code, less_than_or_equal_to: 15

      t.timestamps_with_timezone null: false
    end
  end
end
