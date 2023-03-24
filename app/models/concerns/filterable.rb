# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == Filterable concern
#
# Mixin module containing set of shareable scopes and methods for filtering objects
#

module Filterable
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.instance_eval do
      scope :created_before, -> (date) { where(arel_table[:created_at].lteq(date)) }
      scope :created_after, -> (date) { where(arel_table[:created_at].gteq(date)) }
      scope :created_between, -> (start_date, end_date) do
        where(arel_table[:created_at].between(start_date..end_date))
      end
      scope :updated_before, -> (date) { where(arel_table[:updated_at].lteq(date)) }
      scope :updated_after, -> (date) { where(arel_table[:updated_at].gteq(date)) }
      scope :updated_between, -> (start_date, end_date) do
        where(arel_table[:updated_at].between(start_date..end_date))
      end
    end
  end

  class_methods do
    def filter_by(method)
      simple_filters.fetch(method, -> { all }).call
    end

    def filter_with(filtering_params)
      unless filtering_params.is_a?(Hash)
        raise ArgumentError.new("Input must be a hash")
      end

      results = self.where(nil)
      filtering_params.each do |key, value|
        next results if value.nil?
        if value.is_a?(Array)
          # TODO: Implement for array for boolean, strings, and like other posibilities
          results = results.where(arel_table[key].matches_any(value))
        elsif (value.class.in?([NilClass, FalseClass, TrueClass]) ||
          value =~ ::Medici::Regex.boolean_true_regex ||
          value =~ ::Medici::Regex.boolean_false_regex)
          results = results.where(arel_table[key].eq(value))
        else
          results = results.where(arel_table[key].matches("%#{value}%"))
        end
      end
      results
    end

    private

    def simple_filters
      {
        created_before: -> { created_before },
        created_after: -> { created_after },
        created_between: -> { created_between },
        updated_before: -> { updated_before },
        updated_after: -> { updated_after },
        updated_between: -> { updated_between },
      }
    end
  end
end
