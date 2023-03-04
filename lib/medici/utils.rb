# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Utils
    extend self

    def to_boolean(value, default: nil)
      value = value.to_s if [0, 1].include?(value)

      return value if [true, false].include?(value)
      return true if value =~ ::Medici::Regex.boolean_true_regex
      return false if value =~ ::Medici::Regex.boolean_false_regex

      default
    end

    # A safe alternative to String#downcase!
    #
    # This will make copies of frozen strings but downcase unfrozen
    # strings in place, reducing allocations.
    def safe_downcase!(str)
      if str.frozen?
        str.downcase
      else
        str.downcase! || str
      end
    end

    # Returns array of stripped strings.
    def to_stripped_array(parameter)
      parameter if parameter.is_a?(Array)
      parameter.split(",").map(&:strip)
    end

    def indent(string, width)
      return if !string

      indentation = " " * width
      string.split(/[\n\r]/).map { |line| indentation + line }.join("\n")
    end

    def a_or_an(next_word)
      if next_word =~ /\A[aeiou]/i && next_word != "unique"
        "an #{next_word}"
      else
        "a #{next_word}"
      end
    end

    def dummy_value_for(column_type, array: false)
      if array
        [dummy_value_for(column_type, array: false)]
      else
        case column_type
        when :integer
          0
        when :date
          Date.new(2100, 1, 1)
        when :datetime, :timestamp
          DateTime.new(2100, 1, 1)
        when :time
          Time.new(2000, 1, 1)
        when :uuid
          SecureRandom.uuid
        when :boolean
          true
        else
          "dummy value"
        end
      end
    end
  end
end
