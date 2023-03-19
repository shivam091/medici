# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MedicinesHelper
  def medicines_path
    case
    when current_user.super_admin? then admin_medicines_path
    when current_user.admin? then admin_medicines_path
    when current_user.manager? then manager_medicines_path
    end
  end

  def new_medicine_path
    case
    when current_user.super_admin? then new_admin_medicine_path
    when current_user.admin? then new_admin_medicine_path
    when current_user.manager? then new_manager_medicine_path
    end
  end

  def edit_medicine_path(medicine)
    case
    when current_user.super_admin? then edit_admin_medicine_path(medicine)
    when current_user.admin? then edit_admin_medicine_path(medicine)
    when current_user.manager? then edit_manager_medicine_path(medicine)
    end
  end

  def medicine_path(medicine)
    case
    when current_user.super_admin? then admin_medicine_path(medicine)
    when current_user.admin? then admin_medicine_path(medicine)
    when current_user.manager? then manager_medicine_path(medicine)
    end
  end

  def medicine_object(medicine)
    case
    when current_user.super_admin? then [:admin, medicine]
    when current_user.admin? then [:admin, medicine]
    when current_user.manager? then [:manager, medicine]
    end
  end

  def humanized_strength(medicine)
    "#{medicine.try(:strength)} #{medicine.try(:uom)}"
  end
end
