# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module SuppliersHelper
  def suppliers_path
    case
    when current_user.admin? then admin_suppliers_path
    when current_user.manager? then manager_suppliers_path
    end
  end

  def new_supplier_path
    case
    when current_user.admin? then new_admin_supplier_path
    when current_user.manager? then new_manager_supplier_path
    end
  end

  def edit_supplier_path(supplier)
    case
    when current_user.admin? then edit_admin_supplier_path(supplier)
    when current_user.manager? then edit_manager_supplier_path(supplier)
    end
  end

  def supplier_path(supplier)
    case
    when current_user.admin? then admin_supplier_path(supplier)
    when current_user.manager? then manager_supplier_path(supplier)
    end
  end

  def form_model(supplier)
    case
    when current_user.admin? then [:admin, supplier]
    when current_user.manager? then [:manager, supplier]
    end
  end
end
