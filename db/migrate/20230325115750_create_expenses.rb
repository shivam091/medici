# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateExpenses < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :expenses, id: :uuid do |t|

      t.timestamps_with_timezone null: false
    end
  end
end
