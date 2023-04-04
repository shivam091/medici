# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module SuppliersHelper
  def suppliers_path
    case
    when current_user.admin? then admin_suppliers_path
    when current_user.manager? then manager_suppliers_path
    when current_user.cashier? then cashier_suppliers_path
    end
  end

  def active_suppliers_path
    case
    when current_user.admin? then active_admin_suppliers_path
    when current_user.manager? then active_manager_suppliers_path
    when current_user.cashier? then active_cashier_suppliers_path
    end
  end

  def inactive_suppliers_path
    case
    when current_user.admin? then inactive_admin_suppliers_path
    when current_user.manager? then inactive_manager_suppliers_path
    when current_user.cashier? then inactive_cashier_suppliers_path
    end
  end

  def new_supplier_path
    case
    when current_user.admin? then new_admin_supplier_path
    when current_user.manager? then new_manager_supplier_path
    when current_user.cashier? then new_cashier_supplier_path
    end
  end

  def edit_supplier_path(supplier)
    case
    when current_user.admin? then edit_admin_supplier_path(supplier)
    when current_user.manager? then edit_manager_supplier_path(supplier)
    when current_user.cashier? then edit_cashier_supplier_path(supplier)
    end
  end

  def activate_supplier_path(supplier)
    case
    when current_user.admin? then activate_admin_supplier_path(supplier)
    when current_user.manager? then activate_manager_supplier_path(supplier)
    when current_user.cashier? then activate_cashier_supplier_path(supplier)
    end
  end

  def deactivate_supplier_path(supplier)
    case
    when current_user.admin? then deactivate_admin_supplier_path(supplier)
    when current_user.manager? then deactivate_manager_supplier_path(supplier)
    when current_user.cashier? then deactivate_cashier_supplier_path(supplier)
    end
  end

  def supplier_path(supplier)
    case
    when current_user.admin? then admin_supplier_path(supplier)
    when current_user.manager? then manager_supplier_path(supplier)
    when current_user.cashier? then cashier_supplier_path(supplier)
    end
  end

  def supplier_object(supplier)
    case
    when current_user.admin? then [:admin, supplier]
    when current_user.manager? then [:manager, supplier]
    when current_user.cashier? then [:cashier, supplier]
    end
  end
end
