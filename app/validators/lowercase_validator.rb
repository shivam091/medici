# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# LowercaseValidator
#
# Custom validator for checking whether attribute's value has only lowercase
# charactors.
#
# Example:
#
#   class Model < ActiveRecord::Base
#     validates :attribute, lowercase: true
#   end
#
class LowercaseValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::Medici::Regex.only_lowercase_regex
      if options[:message]
        record.errors.add(attribute, options[:message])
      else
        record.errors.add(attribute, :lowercase)
      end
    end
  end
end
