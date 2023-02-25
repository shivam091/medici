# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module SuppliersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager)/suppliers
      def index
        @suppliers = ::Supplier.active.includes(:address)
        @pagy, @suppliers = pagy(@suppliers)
      end
    end
  end
end
