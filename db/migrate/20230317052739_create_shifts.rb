# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateShifts < Medici::Database::Migration[1.0]
  def change
    create_table_with_constraints :shifts, id: :uuid do |t|
      
    end
  end
end
