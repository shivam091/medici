# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrders::UpdateService < ApplicationService
  def initialize(purchase_order, purchase_order_attributes)
    @purchase_order = purchase_order
    @purchase_order_attributes = purchase_order_attributes.dup
  end

  def call
    update_purchase_order
  end

  private

  attr_reader :purchase_order, :purchase_order_attributes

  def update_purchase_order
    if purchase_order.update(purchase_order_attributes)
      ::ServiceResponse.success(
        message: t("purchase_orders.update.success"),
        payload: {purchase_order: purchase_order}
      )
    else
      ::ServiceResponse.error(
        message: t("purchase_orders.update.error"),
        payload: {purchase_order: purchase_order}
      )
    end
  end
end
