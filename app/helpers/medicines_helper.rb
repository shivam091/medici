# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MedicinesHelper
  def medicines_path
    case
    when current_user.admin? then admin_medicines_path
    when current_user.manager? then manager_medicines_path
    when current_user.cashier? then cashier_medicines_path
    end
  end

  def active_medicines_path
    case
    when current_user.admin? then active_admin_medicines_path
    when current_user.manager? then active_manager_medicines_path
    when current_user.cashier? then active_cashier_medicines_path
    end
  end

  def inactive_medicines_path
    case
    when current_user.admin? then inactive_admin_medicines_path
    when current_user.manager? then inactive_manager_medicines_path
    when current_user.cashier? then inactive_cashier_medicines_path
    end
  end

  def new_medicine_path
    case
    when current_user.admin? then new_admin_medicine_path
    when current_user.manager? then new_manager_medicine_path
    when current_user.cashier? then new_cashier_medicine_path
    end
  end

  def edit_medicine_path(medicine)
    case
    when current_user.admin? then edit_admin_medicine_path(medicine)
    when current_user.manager? then edit_manager_medicine_path(medicine)
    when current_user.cashier? then edit_cashier_medicine_path(medicine)
    end
  end

  def medicine_path(medicine)
    case
    when current_user.admin? then admin_medicine_path(medicine)
    when current_user.manager? then manager_medicine_path(medicine)
    when current_user.cashier? then cashier_medicine_path(medicine)
    end
  end

  def deactivate_medicine_path(medicine)
    case
    when current_user.admin? then deactivate_admin_medicine_path(medicine)
    when current_user.manager? then deactivate_manager_medicine_path(medicine)
    when current_user.cashier? then deactivate_cashier_medicine_path(medicine)
    end
  end

  def activate_medicine_path(medicine)
    case
    when current_user.admin? then activate_admin_medicine_path(medicine)
    when current_user.manager? then activate_manager_medicine_path(medicine)
    when current_user.cashier? then activate_cashier_medicine_path(medicine)
    end
  end

  def medicine_object(medicine)
    case
    when current_user.admin? then [:admin, medicine]
    when current_user.manager? then [:manager, medicine]
    when current_user.cashier? then [:cashier, medicine]
    end
  end

  def humanized_strength(medicine)
    "#{medicine.try(:strength)} #{medicine.try(:uom)}"
  end

  def humanized_stock(medicine)
    pluralize(medicine.try(:quantity_in_hand), medicine.try(:packing_type_name))
  end

  def humanized_replenishment(medicine)
    pluralize(medicine.try(:quantity_pending_from_supplier), medicine.try(:packing_type_name))
  end
end
