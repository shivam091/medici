# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderItems::DestroyService < ApplicationService
  def initialize(purchase_order_item)
    @purchase_order_item = purchase_order_item
  end

  def call
    destroy_purchase_order_item
  end

  private

  attr_reader :purchase_order_item

  def destroy_purchase_order_item
    if purchase_order_item.destroy
      ::ServiceResponse.success(
        message: t("purchase_order_items.destroy.success"),
        payload: {purchase_order_item: purchase_order_item}
      )
    else
      ::ServiceResponse.error(
        message: t("purchase_order_items.destroy.error"),
        payload: {purchase_order_item: purchase_order_item}
      )
    end
  end
end
