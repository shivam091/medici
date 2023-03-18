# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Constraints
      module InclusionConstraint
        # Returns the name for a inclusion constraint
        def inclusion_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "inclusion")
        end

        # Returns definitions for a inclusion constraint
        def inclusion_constraint_definitions(column_name, options)
          values = options[:in].map { |value| quote(value) }.join(", ")

          definitions = "#{quote_column_name(column_name)} IN (#{values})"
          conditions_with_if(definitions, options)
        end

        # Helper for adding inclusion constraint to the column.
        def add_inclusion_constraint(table, column_name, options = {})
          add_check_constraint(
            table,
            inclusion_constraint_definitions(column_name, options),
            name: match_constraint_name(table, column_name, name: options.delete(:name))
          )
        end
      end
    end
  end
end
