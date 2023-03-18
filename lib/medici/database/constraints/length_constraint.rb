# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module LengthConstraint
        COMPARSION_OPERATORS = {
          greater_than: :>,
          greater_than_or_equal_to: :>=,
          equal_to: :"=",
          not_equal_to: :"!=",
          less_than: :<,
          less_than_or_equal_to: :<=
        }.freeze

        # Returns the name for a length constraint
        def length_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "length")
        end

        # Returns definitions for a length constraint
        def length_constraint_definitions(column_name, options)
          definitions = COMPARSION_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            [
              "CHAR_LENGTH(#{quote_column_name(column_name)})",
              operator,
              value
            ].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Helper for adding not null and empty constraint to the column.
        def add_length_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            length_constraint_definitions(column_name, options),
            name: length_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
