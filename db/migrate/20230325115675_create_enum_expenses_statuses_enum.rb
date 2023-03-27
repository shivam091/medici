# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumExpensesStatusesEnum < Medici::Database::Migration[1.0]
  def change
    create_enum :expense_statuses, [:pending, :approved, :rejected]
  end
end
