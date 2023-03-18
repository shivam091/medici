# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module UppercaseConstraint
        # Returns the name for a uppercase constraint
        def uppercase_constraint_name(table, column_name, name: nil)
          name.presence || check_constraint_name(table, column_name, "uppercase")
        end

        # Returns definitions for a uppercase constraint
        def uppercase_constraint_definitions(column_name, options)
          column_name = quote_column_name(column_name)
          definitions = "UPPER(#{column_name}) = #{column_name}"
          conditions_with_if(definitions, options)
        end

        # Helper for adding uppercase constraint to the column.
        def add_uppercase_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            uppercase_constraint_definitions(column_name, options),
            name: uppercase_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
