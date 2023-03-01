# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RemoveDescriptionFromIngredients < Medici::Database::Migration[1.0]
  def change
    reversible do |migrate|
      migrate.up do
        remove_column :ingredients, :description
      end

      migrate.down do
        add_column :ingredients, :description, :text
        add_length_constraint :ingredients, :description, less_than_or_equal_to: 1000
        add_not_null_and_empty_constraint :ingredients, :description
      end
    end
  end
end
