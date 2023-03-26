# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module SQL
    module Functions
      extend self

      def greatest(left, right, column_alias = nil)
        left = quoted(left)
        right = quoted(right)
        if column_alias
          aliased_sql_function("GREATEST", [left, right], column_alias)
        else
          sql_function("GREATEST", [left, right])
        end
      end

      def least(left, right, column_alias = nil)
        left = quoted(left)
        right = quoted(right)
        if column_alias
          aliased_sql_function("LEAST", [left, right], column_alias)
        else
          sql_function("LEAST", [left, right])
        end
      end

      def round(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("ROUND", [value], column_alias)
        else
          sql_function("ROUND", [value])
        end
      end

      def md5(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("MD5", [value], column_alias)
        else
          sql_function("MD5", [value])
        end
      end

      def lower(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("LOWER", [value], column_alias)
        else
          sql_function("LOWER", [value])
        end
      end

      def reverse(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("REVERSE", [value], column_alias)
        else
          sql_function("REVERSE", [value])
        end
      end

      def upper(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("UPPER", [value], column_alias)
        else
          sql_function("UPPER", [value])
        end
      end

      def length(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("LENGTH", [value], column_alias)
        else
          sql_function("LENGTH", [value])
        end
      end

      def concat_with_space(left, right, column_alias = nil)
        space = quoted(Arel.sql("' '"))
        left = quoted(left)
        right = quoted(right)
        if column_alias
          aliased_sql_function("CONCAT", [left, space, right], column_alias)
        else
          sql_function("CONCAT", [left, space, right])
        end
      end

      def date(value, column_alias = nil)
        value = quoted(value)
        if column_alias
          aliased_sql_function("DATE", [value], column_alias)
        else
          sql_function("DATE", [value])
        end
      end

      def aliased_sql_function(name, args, column_alias)
        alias_as_column(sql_function(name, args), column_alias)
      end

      def sql_function(name, args)
        Arel::Nodes::NamedFunction.new(name, args)
      end

      def alias_as_column(value, alias_to)
        Arel::Nodes::As.new(value, Arel::Nodes::SqlLiteral.new(alias_to))
      end

      def quoted(value)
        Arel::Nodes.build_quoted(value)
      end
    end
  end
end
