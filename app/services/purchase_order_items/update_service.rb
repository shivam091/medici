# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderItems::UpdateService < ApplicationService
  def initialize(purchase_order_item, purchase_order_item_attributes)
    @purchase_order_item = purchase_order_item
    @purchase_order_item_attributes = purchase_order_item_attributes.dup
  end

  def call
    update_purchase_order_item
  end

  private

  attr_reader :purchase_order_item, :purchase_order_item_attributes

  def update_purchase_order_item
    if purchase_order_item.update(purchase_order_item_attributes)
      ::ServiceResponse.success(
        message: t("purchase_order_items.update.success"),
        payload: {purchase_order_item: purchase_order_item}
      )
    else
      ::ServiceResponse.error(
        message: t("purchase_order_items.update.error"),
        payload: {purchase_order_item: purchase_order_item}
      )
    end
  end
end
