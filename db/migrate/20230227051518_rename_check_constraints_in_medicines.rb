# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RenameCheckConstraintsInMedicines < Medici::Database::Migration[1.0]
  def change
    reversible do |migrate|
      migrate.up do
        rename_constraint :medicines, :sale_price_lteq_purchase_price, :sell_price_lteq_purchase_price
      end

      migrate.down do
        rename_constraint :medicines, :sell_price_lteq_purchase_price, :sale_price_lteq_purchase_price
      end
    end
  end
end
