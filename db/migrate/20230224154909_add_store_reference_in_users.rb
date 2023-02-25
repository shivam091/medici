# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AddStoreReferenceInUsers < Medici::Database::Migration[1.0]
  def change
    change_table_with_constraints :users do |t|
      t.references :store,
                   type: :uuid,
                   foreign_key: {
                     to_table: :stores,
                     name: :fk_users_store_id_on_stores,
                     on_delete: :cascade
                   },
                   null: true,
                   index: {using: :btree}
    end
  end
end
