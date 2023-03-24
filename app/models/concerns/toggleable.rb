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
        run_callbacks :activate do
          self.update_column(:is_active, true)
        end
      end

      def deactivate!
        run_callbacks :deactivate do
          self.update_column(:is_active, false)
        end
      end
    end

    base_class.extend Callbacks
  end

  class_methods do
    def activate_all!
      all.each do |record|
        record.public_send(:activate!)
      end
    end

    def deactivate_all!
      all.each do |record|
        record.public_send(:deactivate!)
      end
    end
  end

  module Callbacks
    TOGGLEABLE_CALLBACK_EVENTS = [:before, :around, :after].freeze unless const_defined?(:CALLBACK_EVENTS)

    def self.extended(base_class)
      TOGGLEABLE_CALLBACK_EVENTS.each do |event|
        base_class.define_singleton_method("#{event}_activate") do |*args, &block|
          set_callback(:activate, event, *args, &block)
        end
      end
      base_class.define_callbacks :activate

      TOGGLEABLE_CALLBACK_EVENTS.each do |event|
        base_class.define_singleton_method("#{event}_deactivate") do |*args, &block|
          set_callback(:deactivate, event, *args, &block)
        end
      end
      base_class.define_callbacks :deactivate
    end
  end
end
