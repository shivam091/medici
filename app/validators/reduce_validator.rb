# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# ReduceValidator
#
# Custom validator for showing single validation error message for each attribute.
#
# Example:
#
#   class Model < ActiveRecord::Base
#     validates :attribute,
#               presence: true,
#               reduce: true
#   end
#

class ReduceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return until record.errors.messages.has_key?(attribute)
    first_error_message = record.errors[attribute].first
    until record.errors[attribute].size <= 1
      record.errors.delete(attribute)
      record.errors.add(attribute, first_error_message)
    end
  end
end
