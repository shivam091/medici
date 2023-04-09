# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrders::MarkAsReceivedService < ApplicationService
  def initialize(purchase_order)
    @purchase_order = purchase_order
  end

  def call
    mark_purchase_order_as_received!
  end

  private

  attr_reader :purchase_order

  def mark_purchase_order_as_received!
    if purchase_order.mark_as_received!
      ::ServiceResponse.success(
        message: t("purchase_orders.mark_as_received.success"),
        payload: {purchase_order: purchase_order}
      )
    else
      ::ServiceResponse.error(
        message: t("purchase_orders.mark_as_received.error"),
        payload: {purchase_order: purchase_order}
      )
    end
  end
end
