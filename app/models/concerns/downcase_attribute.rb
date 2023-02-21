# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == DowncaseAttribute module
#
# Contains functionality to downcase attributes before validation.
#
# Usage:
#
#     class Model < ApplicationRecord
#       include DowncaseAttribute
#
#       downcase_attributes! :email
#     end
#
module DowncaseAttribute
  extend ActiveSupport::Concern

  class_methods do
    def downcase_attributes!(*attrs)
      attributes_to_downcase.concat(attrs)
    end

    def attributes_to_downcase
      @attributes_to_downcase ||= []
    end
  end

  included do
    before_validation :downcase_attributes!
  end

  def downcase_attributes!
    self.class.attributes_to_downcase.each do |attr|
      self[attr].downcase! if self[attr] && self[attr].respond_to?(:downcase!)
    end
  end
end
