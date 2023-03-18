# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module NotNullConstraint
        # Returns the name for a not null constraint
        def not_null_constraint_name(table, column_name, name: nil)
          name.presence || check_constraint_name(table, column_name, "not_null")
        end

        # Returns definitions for a not null constraint
        def not_null_constraint_definitions(column_name, options)
          definitions = "#{quote_column_name(column_name)} IS NOT NULL"
          conditions_with_if(definitions, options)
        end

        # Helper for adding not null constraint to the column.
        def add_not_null_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            not_null_constraint_definitions(column_name),
            name: not_null_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
