# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# ActiveRecord custom method definitions with timezone information.

module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      # Appends columns `created_at` and `updated_at` to a table.
      #
      # It is used in table creation like:
      # create_table :users do |t|
      #   t.timestamps_with_timezone
      # end
      def timestamps_with_timezone(**options)
        options[:null] = false if options[:null].nil?

        [:created_at, :updated_at].each do |column_name|
          column(column_name, :timestamptz, **options)
        end
      end

      # Disable timestamp alias to datetime
      def aliased_types(name, fallback)
        fallback
      end
    end
  end
end
