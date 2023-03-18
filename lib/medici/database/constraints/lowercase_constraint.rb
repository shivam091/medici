# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module LowercaseConstraint
        # Returns the name for a lowercase constraint
        def lowercase_constraint_name(table, column_name, name: nil)
          name.presence || check_constraint_name(table, column_name, "lowercase")
        end

        # Returns definitions for a lowercase constraint
        def lowercase_constraint_definitions(column_name, options)
          column_name = quote_column_name(column_name)
          definitions = "LOWER(#{column_name}) = #{column_name}"
          conditions_with_if(definitions, options)
        end

        # Helper for adding lowercase constraint to the column.
        def add_lowercase_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            lowercase_constraint_definitions(column_name, options),
            name: lowercase_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
