# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PurchaseOrdersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_purchase_order, only: [:edit, :update, :destroy]
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

      # GET /(admin|manager)/purchase-orders/pending
      def pending
        @purchase_orders = policy_scope(::PurchaseOrder).pending.includes(:purchase_order_medicines)
        @pagy, @purchase_orders = pagy(@purchase_orders)
      end

      # GET /(admin|manager)/purchase-orders/incomplete
      def incomplete
        @purchase_orders = policy_scope(::PurchaseOrder).incomplete.includes(:purchase_order_medicines)
        @pagy, @purchase_orders = pagy(@purchase_orders)
      end

      # GET /(admin|manager)/purchase-orders/received
      def received
        @purchase_orders = policy_scope(::PurchaseOrder).received.includes(:purchase_order_medicines)
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

      # GET /(admin|manager)/purchase-orders/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager)/purchase-orders/:uuid
      def update
        response = ::PurchaseOrders::UpdateService.(@purchase_order, purchase_order_params)
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

      # DELETE /(admin|manager)/purchase-orders/:uuid
      def destroy
        response = ::PurchaseOrders::DestroyService.(@purchase_order)
        @purchase_order = response.payload[:purchase_order]
        if response.success?
          flash[:info] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.purchase_orders_path
      end
    end
  end

  private

  def find_purchase_order
    @purchase_order = policy_scope(::PurchaseOrder).find(params.fetch(:uuid))
  end

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