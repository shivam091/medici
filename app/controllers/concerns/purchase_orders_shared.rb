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

      # GET /(admin|manager)/purchase-orders/new
      def new
        @purchase_order = current_user.purchase_orders.build
      end

      # POST /(admin|manager)/purchase-orders
      def create
        response = ::PurchaseOrders::CreateService.(current_user, purchase_order_params)
        @purchase_order = response.payload[:purchase_order]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.purchase_orders_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:purchase_order_form, partial: "purchase_orders/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end
    end
  end

  private

  def purchase_order_params
    params.require(:purchase_order).permit(
      :supplier_id,
      :invoice_number,
      :tracking_number,
      :ordered_at,
      :expected_arrival_at,
      purchase_order_medicines_attributes: [
        :id,
        :_destroy,
        :medicine_id,
        :quantity,
        :cost,
        :is_received
      ]
    )
  end
end
