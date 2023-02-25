# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AddIsMainStoreInStores < Medici::Database::Migration[1.0]
  def change
    change_table_with_constraints :stores do |t|
      t.boolean :is_main_store, default: false 
    end
  end
end
