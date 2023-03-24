# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == Toggleable concern
#
# Mixin module containing set of shareable scopes and methods for activating and
# deactivating objects.
#

module Toggleable
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.instance_eval do
      attribute :is_active, default: false

      scope :inactive, -> { where(arel_table[:is_active].eq(false)) }
      scope :active, -> { where(arel_table[:is_active].eq(true)) }
    end

    base_class.class_eval do
      def activate!
        self.update_column(:is_active, true)
      end

      def deactivate!
        self.update_column(:is_active, false)
      end
    end
  end

  class_methods do
  end
end
