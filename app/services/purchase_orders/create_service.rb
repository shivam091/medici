# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrders::CreateService < ApplicationService
  def initialize(user, purchase_order_attributes)
    @user = user
    @purchase_order_attributes = purchase_order_attributes.dup
  end

  def call
    create_purchase_order
  end

  private

  attr_reader :user, :purchase_order_attributes

  def create_purchase_order
    purchase_order = user.purchase_orders.build(purchase_order_attributes)
    if purchase_order.save
      ::ServiceResponse.success(
        message: t("purchase_orders.create.success"),
        payload: {purchase_order: purchase_order}
      )
    else
      ::ServiceResponse.error(
        message: t("purchase_orders.create.error"),
        payload: {purchase_order: purchase_order}
      )
    end
  end
end
