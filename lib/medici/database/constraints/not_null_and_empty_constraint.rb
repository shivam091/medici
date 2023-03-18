# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module NotNullAndEmptyConstraint
        # Returns the name for a not null and empty constraint
        def not_null_and_empty_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "not_null_and_empty")
        end

        # Returns definitions for a not null and empty constraint
        def not_null_and_empty_constraint_definitions(column_name, options)
          definitions = [
            not_null_constraint_definitions(column_name, options),
            not_empty_constraint_definitions(column_name, options)
          ].join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Helper for adding not null and empty constraint to the column.
        def add_not_null_and_empty_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            not_null_and_empty_constraint_definitions(column_name, options),
            name: not_null_and_empty_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
