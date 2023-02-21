# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Database
    module Migrations
      module ConstraintsHelpers
        COMPARSION_OPERATORS = {
          greater_than: :>,
          greater_than_or_equal_to: :>=,
          equal_to: :"=",
          not_equal_to: :"!=",
          less_than: :<,
          less_than_or_equal_to: :<=
        }.freeze

        MATCH_OPERATORS = {
          accepts: :~,
          accepts_case_insensitive: :"~*",
          rejects: :"!~",
          rejects_case_insensitive: :"!~*"
        }.freeze

        # Returns the name for a check constraint
        #
        # type:
        # - Any value, as long as it is unique
        # - Constraint names are unique per table in Postgres, and, additionally,
        #   we can have multiple check constraints over a column
        #   So we use the (table, column, type) triplet as a unique name
        # - e.g. we use 'max_length' when adding checks for text limits
        #        or 'not_null' when adding a NOT NULL constraint
        #
        def check_constraint_name(table, column, type)
          identifier = "#{table}_#{column}_check_#{type}"
          hashed_identifier = Digest::SHA256.hexdigest(identifier).first(10)

          "chk_#{hashed_identifier}"
        end

        # Returns the name for a not null constraint
        def not_null_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "not_null")
        end

        # Returns the name for a not empty constraint
        def not_empty_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "not_empty")
        end

        # Returns the name for a not null and empty constraint
        def not_null_and_empty_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "not_null_and_empty")
        end

        # Returns the name for a length constraint
        def length_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "length")
        end

        # Returns the name for a numericality constraint
        def numericality_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "numericality")
        end

        # Returns the name for a match constraint
        def match_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "match")
        end

        # Returns the name for a inclusion constraint
        def inclusion_constraint_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, "inclusion")
        end

        def conditions_with_if(conditions, options = {})
          if options[:if].present?
            "NOT (#{options[:if]}) OR (#{conditions})"
          else
            conditions
          end
        end

        # Returns definitions for a length constraint
        def length_constraint_definitions(column_name, options)
          definitions = COMPARSION_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            ["CHAR_LENGTH(#{column_name})", operator, value].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a numericality constraint
        def numericality_constraint_definitions(column_name, options)
          definitions = COMPARSION_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            [column_name, operator, value].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a match constraint
        def match_constraint_definitions(column_name, options)
          definitions = MATCH_OPERATORS.slice(*options.keys).map do |key, operator|
            value = options[key]
            [column_name, operator, "'#{value}'"].join(" ")
          end.join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a not null constraint
        def not_null_constraint_definitions(column_name, options)
          definitions = "#{column_name} IS NOT NULL"
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a not empty constraint
        def not_empty_constraint_definitions(column_name, options)
          definitions = "#{column_name} <> ''"
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a not null and empty constraint
        def not_null_and_empty_constraint_definitions(column_name, options)
          definitions = [
            not_null_constraint_definitions(column_name, options),
            not_empty_constraint_definitions(column_name, options)
          ].join(" AND ")
          conditions_with_if(definitions, options)
        end

        # Returns definitions for a inclusion constraint
        def inclusion_constraint_definitions(column_name, options)
          values = options[:in].map { |value| quote(value) }.join(", ")

          definitions = "#{column_name} IN (#{values})"
          conditions_with_if(definitions, options)
        end

        # Helper for adding not null constraint to the column.
        def add_not_null_constraint(table, column_name, name: nil)
          column_name = quote_column_name(column_name)

          add_check_constraint(
            table,
            not_null_constraint_definitions(column_name),
            name: not_null_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding not empty constraint to the column.
        def add_not_empty_constraint(table, column_name, name: nil)
          column_name = quote_column_name(column_name)

          add_check_constraint(
            table,
            not_empty_constraint_definitions(column_name),
            name: not_empty_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding not null and empty constraint to the column.
        def add_not_null_and_empty_constraint(table, column_name, name: nil)
          column_name = quote_column_name(column_name)

          add_check_constraint(
            table,
            not_null_and_empty_constraint_definitions(column_name),
            name: not_null_and_empty_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding not null and empty constraint to the column.
        def add_length_constraint(table, column_name, options = {})
          column_name = quote_column_name(column_name)
          name = options.delete(:name)

          add_check_constraint(
            table,
            length_constraint_definitions(column_name, options),
            name: length_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding numericality constraint to the column.
        def add_numericality_constraint(table, column_name, options = {})
          column_name = quote_column_name(column_name)
          name = options.delete(:name)

          add_check_constraint(
            table,
            numericality_constraint_definitions(column_name, options),
            name: numericality_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding match constraint to the column.
        def add_match_constraint(table, column_name, options = {})
          column_name = quote_column_name(column_name)
          name = options.delete(:name)

          add_check_constraint(
            table,
            match_constraint_definitions(column_name, options),
            name: match_constraint_name(table, column_name, name: name)
          )
        end

        # Helper for adding inclusion constraint to the column.
        def add_inclusion_constraint(table, column_name, options = {})
          column_name = quote_column_name(column_name)
          name = options.delete(:name)

          add_check_constraint(
            table,
            inclusion_constraint_definitions(column_name, options),
            name: match_constraint_name(table, column_name, name: name)
          )
        end

        def rename_constraint(table_name, old_name, new_name)
          execute <<~SQL
            ALTER TABLE #{quote_table_name(table_name)}
            RENAME CONSTRAINT #{quote_column_name(old_name)} TO #{quote_column_name(new_name)}
          SQL
        end
      end
    end
  end
end
