# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PurchaseOrderItemsHelper
  def edit_purchase_order_item_path(purchase_order, purchase_order_item)
    case
    when current_user.admin? then
      edit_admin_purchase_order_purchase_order_item_path(purchase_order, purchase_order_item)
    when current_user.manager? then
      edit_manager_purchase_order_purchase_order_item_path(purchase_order, purchase_order_item)
    end
  end

  def purchase_order_item_path(purchase_order, purchase_order_item)
    case
    when current_user.admin? then
      admin_purchase_order_purchase_order_item_path(purchase_order, purchase_order_item)
    when current_user.manager? then
      manager_purchase_order_purchase_order_item_path(purchase_order, purchase_order_item)
    end
  end

  def purchase_order_item_object(purchase_order, purchase_order_item)
    case
    when current_user.admin? then [:admin, purchase_order, purchase_order_item]
    when current_user.manager? then [:manager, purchase_order, purchase_order_item]
    end
  end
end
