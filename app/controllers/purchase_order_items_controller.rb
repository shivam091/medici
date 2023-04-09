# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderItemsController < ApplicationController
  before_action :find_purchase_order

  private

  def find_purchase_order
    @purchase_order = policy_scope(::PurchaseOrder).find(params.fetch(:purchase_order_uuid))
  end
end
