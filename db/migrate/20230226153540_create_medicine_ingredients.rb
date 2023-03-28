# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateMedicineIngredients < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :medicine_ingredients, id: :uuid do |t|
      t.references :medicine,
                   type: :uuid,
                   foreign_key: {
                     to_table: :medicines,
                     name: :fk_medicine_ingredients_medicine_id_on_medicines,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :ingredient,
                   type: :uuid,
                   foreign_key: {
                     to_table: :ingredients,
                     name: :fk_medicine_ingredients_ingredient_id_on_ingredients,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.boolean :active, default: false
      t.decimal :strength, precision: 8, scale: 2
      t.enum :uom, enum_type: :unit_of_measures

      t.not_null_constraint :strength
      t.not_null_constraint :uom
      t.not_null_constraint :medicine_id
      t.not_null_constraint :ingredient_id

      t.timestamps_with_timezone null: false
    end
  end
end
