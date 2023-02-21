# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == Strippable Attribute module
#
# Contains functionality to strip attributes before validation
#
# Usage:
#
#   class Model < ApplicationRecord
#     include StripAttribute
#
#     strip_attributes! :attribute
#   end
#
module StripAttribute
  extend ActiveSupport::Concern

  class_methods do
    def strip_attributes!(*attrs)
      attributes_to_strip.concat(attrs)
    end

    def attributes_to_strip
      @attributes_to_strip ||= []
    end
  end

  included do
    before_validation :strip_attributes!
  end

  def strip_attributes!
    self.class.attributes_to_strip.each do |attr|
      self[attr].strip! if self[attr] && self[attr].respond_to?(:strip!)
    end
  end
end
