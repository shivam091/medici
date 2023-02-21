# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# UppercaseValidator
#
# Custom validator for checking whether attribute's value has only uppercase
# charactors.
#
# Example:
#
#   class Model < ActiveRecord::Base
#     validates :attribute, uppercase: true
#   end
#
class UppercaseValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::Medici::Regex.only_uppercase_regex
      if options[:message]
        record.errors.add(attribute, options[:message])
      else
        record.errors.add(attribute, :uppercase)
      end
    end
  end
end
