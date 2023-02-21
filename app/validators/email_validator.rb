# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# EmailValidator
#
# Custom validator for checking whether attribute's value is valid email.
#
# Example:
#
#   class Model < ActiveRecord::Base
#     validates :attribute, email: true
#   end
#
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::Medici::Regex.email_regex
      if options[:message]
        record.errors.add(attribute, options[:message])
      else
        record.errors.add(attribute, :invalid)
      end
    end
  end
end
