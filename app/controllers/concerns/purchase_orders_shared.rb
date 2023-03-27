# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PurchaseOrdersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do
      before_action do
        if action_name.in?(["edit", "update", "destroy"])
          authorize @purchase_order
        else
          authorize ::PurchaseOrder
        end
      end

      # GET /(admin|manager)/purchase-orders
      def index
        @purchase_orders = policy_scope(::PurchaseOrder).includes(:purchase_order_medicines)
        @pagy, @purchase_orders = pagy(@purchase_orders)
      end
    end
  end
end
