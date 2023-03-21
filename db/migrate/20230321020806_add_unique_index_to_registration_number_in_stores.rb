# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AddUniqueIndexToRegistrationNumberInStores < ActiveRecord::Migration[7.0]
  def change
    add_index :stores, :registration_number, using: :btree, unique: true
  end
end
