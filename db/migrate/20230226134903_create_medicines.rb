# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateMedicines < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :medicines, id: :uuid do |t|
      t.references :medicine_category,
                   type: :uuid,
                   foreign_key: {
                     to_table: :medicine_categories,
                     name: :fk_medicines_medicine_category_id_on_medicine_categories,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :dosage_form,
                   type: :uuid,
                   foreign_key: {
                     to_table: :dosage_forms,
                     name: :fk_medicines_dosage_form_id_on_dosage_forms,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :packing_type,
                   type: :uuid,
                   foreign_key: {
                     to_table: :packing_types,
                     name: :fk_medicines_packing_type_id_on_packing_types,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :manufacturer,
                   type: :uuid,
                   foreign_key: {
                     to_table: :manufacturers,
                     name: :fk_medicines_manufacturer_id_on_manufacturers,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_medicines_user_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_medicines_store_id_on_stores,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.string :reference_code, index: {using: :btree, unique: true}
      t.string :name
      t.text :description
      t.string :batch_number, index: {using: :btree}
      t.decimal :purchase_price, precision: 8, scale: 2
      t.decimal :sell_price, precision: 8, scale: 2
      t.date :manufacture_date
      t.date :expiry_date
      t.string :proprietary_name
      t.decimal :strength, precision: 8, scale: 2
      t.enum :uom, enum_type: :unit_of_measures
      t.integer :pack_size
      t.string :therapeutic_areas
      t.boolean :is_active, default: false, index: {using: :btree}

      t.not_null_constraint :store_id
      t.not_null_constraint :user_id
      t.not_null_constraint :packing_type_id
      t.not_null_constraint :dosage_form_id
      t.not_null_constraint :manufacturer_id
      t.not_null_constraint :medicine_category_id

      t.not_null_constraint :purchase_price
      t.not_null_constraint :sell_price
      t.not_null_constraint :manufacture_date
      t.not_null_constraint :expiry_date

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :reference_code
      t.not_null_and_empty_constraint :batch_number

      t.length_constraint :reference_code, less_than_or_equal_to: 15
      t.length_constraint :name, less_than_or_equal_to: 255
      t.length_constraint :description, less_than_or_equal_to: 1000
      t.length_constraint :batch_number, less_than_or_equal_to: 55
      t.length_constraint :proprietary_name, less_than_or_equal_to: 255
      t.length_constraint :therapeutic_areas, less_than_or_equal_to: 255

      t.check_constraint "sell_price <= purchase_price", name: "sell_price_lteq_purchase_price"
      t.check_constraint "manufacture_date <= CURRENT_DATE", name: "manufacture_date_lteq_today"
      t.check_constraint "expiry_date > CURRENT_DATE", name: "manufacture_date_gt_today"
      t.check_constraint "manufacture_date < expiry_date", name: "expiry_date_gt_manufacture_date"

      t.timestamps_with_timezone null: false
    end
  end
end
