# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module NumericalityConstraint
        COMPARSION_OPERATORS = {
          greater_than: :>,
          greater_than_or_equal_to: :>=,
          equal_to: :"=",
          not_equal_to: :"!=",
          less_than: :<,
          less_than_or_equal_to: :<=
        }.freeze

        # Returns the name for a numericality constraint
        def numericality_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "numericality")
        end

        # Returns definitions for a numericality constraint
        def numericality_constraint_definitions(column_name, options)
          definitions = COMPARSION_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            [quote_column_name(column_name), operator, value].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Helper for adding numericality constraint to the column.
        def add_numericality_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            numericality_constraint_definitions(column_name, options),
            name: numericality_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
