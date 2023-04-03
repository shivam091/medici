# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ManufacturersHelper
  def manufacturers_path
    case
    when current_user.super_admin? then admin_manufacturers_path
    when current_user.admin? then admin_manufacturers_path
    when current_user.manager? then manager_manufacturers_path
    end
  end

  def active_manufacturers_path
    case
    when current_user.super_admin? then active_admin_manufacturers_path
    when current_user.admin? then active_admin_manufacturers_path
    when current_user.manager? then active_manager_manufacturers_path
    end
  end

  def inactive_manufacturers_path
    case
    when current_user.super_admin? then inactive_admin_manufacturers_path
    when current_user.admin? then inactive_admin_manufacturers_path
    when current_user.manager? then inactive_manager_manufacturers_path
    end
  end

  def new_manufacturer_path
    case
    when current_user.super_admin? then new_admin_manufacturer_path
    when current_user.admin? then new_admin_manufacturer_path
    when current_user.manager? then new_manager_manufacturer_path
    end
  end

  def edit_manufacturer_path(manufacturer)
    case
    when current_user.super_admin? then edit_admin_manufacturer_path(manufacturer)
    when current_user.admin? then edit_admin_manufacturer_path(manufacturer)
    when current_user.manager? then edit_manager_manufacturer_path(manufacturer)
    end
  end

  def activate_manufacturer_path(manufacturer)
    case
    when current_user.super_admin? then activate_admin_manufacturer_path(manufacturer)
    when current_user.admin? then activate_admin_manufacturer_path(manufacturer)
    when current_user.manager? then activate_manager_manufacturer_path(manufacturer)
    end
  end

  def deactivate_manufacturer_path(manufacturer)
    case
    when current_user.super_admin? then deactivate_admin_manufacturer_path(manufacturer)
    when current_user.admin? then deactivate_admin_manufacturer_path(manufacturer)
    when current_user.manager? then deactivate_manager_manufacturer_path(manufacturer)
    end
  end

  def manufacturer_path(manufacturer)
    case
    when current_user.super_admin? then admin_manufacturer_path(manufacturer)
    when current_user.admin? then admin_manufacturer_path(manufacturer)
    when current_user.manager? then manager_manufacturer_path(manufacturer)
    when current_user.cashier? then cashier_manufacturer_path(manufacturer)
    end
  end

  def manufacturer_object(manufacturer)
    case
    when current_user.super_admin? then [:admin, manufacturer]
    when current_user.admin? then [:admin, manufacturer]
    when current_user.manager? then [:manager, manufacturer]
    end
  end
end
