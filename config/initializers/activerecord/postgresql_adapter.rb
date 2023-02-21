# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "active_record/connection_adapters/postgresql_adapter"

module ActiveRecord
  module ConnectionAdapters
    if const_defined?(:PostgreSQLAdapter)
      class PostgreSQLAdapter
        NATIVE_DATABASE_TYPES.merge!(
          enum: { name: "enum" },
          # there is a chance the above causes conflicts in some cases, you can
          # always be more explicit and actually use your type or names (I am
          # not looking up which)
          # type_priority:    { name: 'enum' }
        )

        # Helper method used by the monkeypatch internals. Provides a hash of
        # ENUM types as they exist currently.
        #
        # Example:
        #
        #   { "foo_type" => ["foo", "bar", "baz"] }
        def enum_types
          res = exec_query(<<-SQL.strip_heredoc, "SCHEMA")
            SELECT t.typname AS enum_name, array_agg(e.enumlabel ORDER BY e.enumsortorder) AS enum_value
            FROM pg_type t
            JOIN pg_enum e ON t.oid = e.enumtypid
            JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
            WHERE n.nspname = ANY (current_schemas(false))
            GROUP BY enum_name;
          SQL

          coltype = res.column_types["enum_value"]
          deserialize = if coltype.respond_to?(:deserialize)
            proc { |values| coltype.deserialize(values) }
          elsif coltype.respond_to?(:type_cast_from_database)
            proc { |values| coltype.type_cast_from_database(values) }
          else
            proc { |values| coltype.type_cast(values) }
          end

          res.rows
            .map { |name, values| [name, values] }
            .sort { |a, b| a.first <=> b.first }
            .each_with_object({}) { |(name, values), memo| memo[name] = deserialize.call(values) }
        end

        # Drop an ENUM type from the database.
        #
        # Options:
        #   if_exists: to check whether enum exists before dropping it
        #   force:     specify whether cascade operation is to be performed before
        #              dropping the enum
        #
        # Example:
        #
        #   drop_enum "enum_name", if_exists: true, force: false
        #
        def drop_enum(name, values, options = {})
          sql = "DROP TYPE#{' IF EXISTS' if options[:if_exists]} #{quote_table_name(name)}"
          sql << " CASCADE" if options[:force]

          execute(sql).tap { reload_type_map }
        end

        # Rename an existing ENUM type
        #
        # Options:
        #   to: new name of the enum
        #
        # Example:
        #
        #   rename_enum "old_name", to: "new_name"
        def rename_enum(name, options = {})
          to = options.fetch(:to) { raise ArgumentError, ":to is required" }

          sql = "ALTER TYPE #{quote_table_name(name)} RENAME TO #{to}"

          execute(sql).tap { reload_type_map }
        end

        # Add a new value to an existing ENUM type.
        # Only one value at a time is supported by PostgreSQL.
        #
        # Options:
        #   before:        value to add BEFORE the given value
        #   after:         value to add AFTER the given value
        #   if_not_exists: speciify if value is added to enum only if it is not
        #                  present in the enum
        #
        # Example:
        #
        #   add_enum_value("foo_type", "lorem", before: "bar", if_not_exists: true)
        def add_enum_value(type, value, options = {})
          before, after = options.values_at(:before, :after)
          sql = "ALTER TYPE #{quote_table_name(type)} ADD VALUE#{' IF NOT EXISTS' if options[:if_not_exists]} '#{value}'"

          if before && after
            raise ArgumentError, "Cannot have both :before and :after at the same time"
          elsif before
            sql << " BEFORE '#{before}'"
          elsif after
            sql << " AFTER '#{after}'"
          end

          execute(sql).tap { reload_type_map }
        end

        # Change the label of an existing ENUM value
        #
        # Options:
        #   from: The original label string
        #   to:   The desired label string
        #
        # Example:
        #
        #   rename_enum_value "foo_type", from: "lorem", to: "Quux"
        #
        def rename_enum_value(type, options = {})
          from = options.fetch(:from) { raise ArgumentError, ":from is required" }
          to   = options.fetch(:to)   { raise ArgumentError, ":to is required" }

          sql = "ALTER TYPE #{quote_table_name(type)} RENAME VALUE '#{from}' TO '#{to}'"

          execute(sql).tap { reload_type_map }
        end
      end
    end
  end
end
