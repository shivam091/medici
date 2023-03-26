# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateDiscounts < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :discounts, id: :uuid do |t|
      t.references :country,
                         type: :uuid,
                         foreign_key: {
                           to_table: :countries,
                           name: :fk_discounts_country_id_on_countries,
                           on_delete: :restrict
                         },
                         index: {using: :btree, unique: true}
      t.decimal :percent_off, precision: 8, scale: 2, default: 0.0

      t.not_null_constraint :country_id
      t.not_null_constraint :percent_off

      t.numericality_constraint :percent_off, greater_than_or_equal_to: 0.0

      t.timestamps_with_timezone null: false
    end
  end
end
