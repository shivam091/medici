# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require_relative "constraints/inclusion_constraint"
require_relative "constraints/length_constraint"
require_relative "constraints/lowercase_constraint"
require_relative "constraints/match_constraint"
require_relative "constraints/not_empty_constraint"
require_relative "constraints/not_null_and_empty_constraint"
require_relative "constraints/not_null_constraint"
require_relative "constraints/numericality_constraint"
require_relative "constraints/uppercase_constraint"

module Medici
  module Database
    module Migrations
      module ConstraintsHelpers
        include Constraints::InclusionConstraint
        include Constraints::LengthConstraint
        include Constraints::LowercaseConstraint
        include Constraints::MatchConstraint
        include Constraints::NotEmptyConstraint
        include Constraints::NotNullAndEmptyConstraint
        include Constraints::NotNullConstraint
        include Constraints::NumericalityConstraint
        include Constraints::UppercaseConstraint

        def conditions_with_if(conditions, options = {})
          if options[:if].present?
            "NOT (#{options[:if]}) OR (#{conditions})"
          else
            conditions
          end
        end

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
