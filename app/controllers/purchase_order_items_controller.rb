# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderItemsController < ApplicationController
  before_action :find_purchase_order, :find_purchase_order_item
  before_action { authorize @purchase_order_item }

  # GET /(:role)/purchase-orders/:purchase_order_uuid/purchase-order-items/:uuid/edit
  def edit
  end

  # PUT|PATCH /(:role)/purchase-orders/:purchase_order_uuid/purchase-order-items/:uuid
  def update
    response = ::PurchaseOrderItems::UpdateService.(@purchase_order_item, purchase_order_item_params)
    @purchase_order_item = response.payload[:purchase_order_item]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.purchase_orders_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:purchase_order_item_form, partial: "purchase_order_items/form")
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /(:role)/purchase-orders/:purchase_order_uuid/purchase-order-items/:uuid
  def destroy
  end

  private

  def find_purchase_order
    @purchase_order = policy_scope(::PurchaseOrder).find(params.fetch(:purchase_order_uuid))
  end

  def find_purchase_order_item
    @purchase_order_item = @purchase_order.purchase_order_items.find(params.fetch(:uuid))
  end

  def purchase_order_item_params
    params.require(:purchase_order_item).permit(
      :medicine_id,
      :quantity,
      :cost,
      :is_received
    )
  end
end
