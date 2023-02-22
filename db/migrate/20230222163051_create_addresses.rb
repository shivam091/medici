# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateAddresses < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :addresses, id: :uuid do |t|
      t.references :country,
                   type: :uuid,
                   foreign_key: {
                     to_table: :countries,
                     name: :fk_addresses_country_id_on_countries,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :addressable,
                   type: :uuid,
                   polymorphic: true,
                   index: {using: :btree}
      t.string :address1
      t.string :address2
      t.string :city
      t.string :region
      t.string :postal_code

      t.length_constraint :address1, less_than_or_equal_to: 100
      t.length_constraint :address2, less_than_or_equal_to: 100
      t.length_constraint :city, less_than_or_equal_to: 100
      t.length_constraint :region, less_than_or_equal_to: 100
      t.length_constraint :postal_code, less_than_or_equal_to: 20

      t.not_null_and_empty_constraint :address1
      t.not_null_and_empty_constraint :city

      t.not_null_constraint :country_id
      t.not_null_constraint :addressable_id
      t.not_null_constraint :addressable_type

      t.timestamps_with_timezone null: false
    end
  end
end
