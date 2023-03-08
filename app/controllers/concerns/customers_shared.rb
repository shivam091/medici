# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module CustomersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager|cashier)/suppliers
      def index
        @customers = ::Customer.active.includes(:address)
        @pagy, @customers = pagy(@customers)
      end
    end
  end
end
