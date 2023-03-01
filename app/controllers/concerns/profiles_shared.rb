# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ProfilesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager|cashier)/profile
      def show
      end
    end
  end
end
