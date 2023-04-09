# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PurchaseOrdersHelper
  def purchase_orders_path
    case
    when current_user.admin? then admin_purchase_orders_path
    when current_user.manager? then manager_purchase_orders_path
    end
  end

  def pending_purchase_orders_path
    case
    when current_user.admin? then pending_admin_purchase_orders_path
    when current_user.manager? then pending_manager_purchase_orders_path
    end
  end

  def incomplete_purchase_orders_path
    case
    when current_user.admin? then incomplete_admin_purchase_orders_path
    when current_user.manager? then incomplete_manager_purchase_orders_path
    when current_user.cashier? ten incomplete_cashier_purchase_orders_path
    end
  end

  def received_purchase_orders_path
    case
    when current_user.admin? then received_admin_purchase_orders_path
    when current_user.manager? then received_manager_purchase_orders_path
    end
  end

  def new_purchase_order_path
    case
    when current_user.admin? then new_admin_purchase_order_path
    when current_user.manager? then new_manager_purchase_order_path
    end
  end

  def edit_purchase_order_path(purchase_order)
    case
    when current_user.admin? then edit_admin_purchase_order_path(purchase_order)
    when current_user.manager? then edit_manager_purchase_order_path(purchase_order)
    end
  end

  def purchase_order_path(purchase_order)
    case
    when current_user.admin? then admin_purchase_order_path(purchase_order)
    when current_user.manager? then manager_purchase_order_path(purchase_order)
    end
  end

  def mark_as_received_purchase_order_path(purchase_order)
    case
    when current_user.admin? then mark_as_received_admin_purchase_order_path(purchase_order)
    when current_user.manager? then mark_as_received_manager_purchase_order_path(purchase_order)
    end
  end

  def purchase_order_object(purchase_order)
    case
    when current_user.admin? then [:admin, purchase_order]
    when current_user.manager? then [:manager, purchase_order]
    end
  end
end
