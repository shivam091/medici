# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require File.expand_path("../constraints_helper", __FILE__)

module Medici
  module Database
    class Migration
      # This implements a simple versioning scheme for migration helpers.
      #
      # We need to be able to version helpers, so we can change their behavior without
      # altering the behavior of already existing migrations in incompatible ways.
      #
      # We can continue to change the behavior of helpers without bumping the version here,
      # *if* the change is backwards-compatible.
      #
      # If not, we would typically override the helper method in a new MigrationHelpers::V[0-9]+
      # class and create a new entry with a bumped version below.
      #
      # We use major version bumps to indicate significant changes and minor version bumps
      # to indicate backwards-compatible or otherwise minor changes (e.g. a Rails version bump).
      # However, this hasn't been strictly formalized yet.

      class V1_0 < ActiveRecord::Migration[7.0]
        include Migrations::ConstraintsHelpers

        # When running migrations, the `db:migrate` switches connection of
        # ActiveRecord::Base depending where the migration runs.
        # This helper class is provided to avoid confusion using `ActiveRecord::Base`
        class MigrationRecord < ActiveRecord::Base
          self.abstract_class = true # Prevent STI behavior
        end

        def create_table_with_constraints(table_name, **options, &block)
          helper_context = self

          create_table(table_name, **options) do |t|

            t.define_singleton_method(:not_null_constraint) do |column_name, options = {}|
              name = helper_context.send(:not_null_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:not_null_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:not_empty_constraint) do |column_name, options = {}|
              name = helper_context.send(:not_empty_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:not_empty_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:not_null_and_empty_constraint) do |column_name, options = {}|
              name = helper_context.send(:not_null_and_empty_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:not_null_and_empty_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:length_constraint) do |column_name, options = {}|
              name = helper_context.send(:length_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:length_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:numericality_constraint) do |column_name, options = {}|
              name = helper_context.send(:numericality_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:numericality_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:match_constraint) do |column_name, options = {}|
              name = helper_context.send(:match_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:match_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:inclusion_constraint) do |column_name, options = {}|
              name = helper_context.send(:inclusion_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:inclusion_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:uppercase_constraint) do |column_name, options = {}|
              name = helper_context.send(:uppercase_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:uppercase_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.define_singleton_method(:lowercase_constraint) do |column_name, options = {}|
              name = helper_context.send(:lowercase_constraint_name, table_name, column_name, name: options.delete(:name))
              column_name = helper_context.quote_column_name(column_name)
              definition = helper_context.send(:lowercase_constraint_definitions, column_name, options)

              t.check_constraint(definition, name: name)
            end

            t.instance_eval(&block) if block_given?
          end
        end
      end

      def self.[](version)
        version = version.to_s
        name = "V#{version.tr(".", "_")}"
        raise ArgumentError, "Unknown migration version: #{version}" unless const_defined?(name, false)

        const_get(name, false)
      end

      # The current version to be used in new migrations
      def self.current_version
        1.0
      end
    end
  end
end
