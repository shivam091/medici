# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Validatable
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # Checks whether an attribute has failed validation or not
      #
      # +attribute+ The symbolised name of the attribute i.e :name
      def valid_attribute?(attribute)
        self.errors.empty? || self.errors.messages[attribute].empty?
      end

      def valid_attributes?(*attributes)
        attributes.each do |attribute|
          self.class.validators_on(attribute).each do |validator|
            validator.validate_each(self, attribute, send(attribute))
          end
        end
        errors.none?
      end

      def validate_attributes!(*attributes)
        valid_attributes?(*attributes) || raise(ActiveModel::ValidationError.new(self))
      end
    end
  end
end
