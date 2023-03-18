# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module MatchConstraint
        MATCH_OPERATORS = {
          accepts: :~,
          accepts_case_insensitive: :"~*",
          rejects: :"!~",
          rejects_case_insensitive: :"!~*"
        }.freeze

        # Returns the name for a match constraint
        def match_constraint_name(table, column_name, name: nil)
          name.presence || check_constraint_name(table, column_name, "match")
        end

        # Returns definitions for a match constraint
        def match_constraint_definitions(column_name, options)
          definitions = MATCH_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            [quote_column_name(column_name), operator, "'#{value}'"].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Helper for adding match constraint to the column.
        def add_match_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            match_constraint_definitions(column_name, options),
            name: match_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
