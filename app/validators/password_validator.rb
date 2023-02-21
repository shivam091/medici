# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# PasswordValidator
#
# Custom validator for checking whether attribute's value has valid password format.
# It requires lowercase, uppercase letters, atleast one number, and atleast one
# special character
#
# Example:
#
#   class Model < ActiveRecord::Base
#     validates :attribute, password: true
#   end
#
class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::Medici::Regex.strong_password_regex
      if options[:message]
        record.errors.add(attribute, options[:message])
      else
        record.errors.add(attribute, :invalid)
      end
    end
  end
end
