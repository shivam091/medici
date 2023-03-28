# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCountries < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :countries, id: :uuid do |t|
      t.string :name, index: {using: :btree, unique: true}
      t.string :iso2, index: {using: :btree, unique: true}
      t.string :iso3, index: {using: :btree, unique: true}
      t.string :calling_code
      t.boolean :has_postal_code, default: false
      t.boolean :is_active, default: false, index: {using: :btree}
      t.references :currency,
                   type: :uuid,
                   foreign_key: {
                     to_table: :currencies,
                     name: :fk_countries_currency_id_on_currencies,
                     on_delete: :restrict
                   },
                   index: {using: :btree}

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :iso2
      t.not_null_and_empty_constraint :iso3

      t.not_null_constraint :currency_id

      t.length_constraint :name, less_than_or_equal_to: 55
      t.length_constraint :iso2, equal_to: 2
      t.length_constraint :iso3, equal_to: 3

      t.uppercase_constraint :iso2
      t.uppercase_constraint :iso3

      t.timestamps_with_timezone null: false
    end
  end
end
