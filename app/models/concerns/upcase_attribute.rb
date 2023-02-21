# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == UpcaseAttribute module
#
# Contains functionality to upcase attributes before validation.
#
# Usage:
#
#   class Model < ApplicationRecord
#     include UpcaseAttribute
#
#     upcase_attributes! :attribute
#   end
#
module UpcaseAttribute
  extend ActiveSupport::Concern

  class_methods do
    def upcase_attributes!(*attrs)
      attributes_to_upcase.concat(attrs)
    end

    def attributes_to_upcase
      @attributes_to_upcase ||= []
    end
  end

  included do
    before_validation :upcase_attributes!
  end

  def upcase_attributes!
    self.class.attributes_to_upcase.each do |attr|
      self[attr].upcase! if self[attr] && self[attr].respond_to?(:upcase!)
    end
  end
end
