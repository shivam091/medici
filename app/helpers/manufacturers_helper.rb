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

  def manufacturer_path(manufacturer)
    case
    when current_user.super_admin? then admin_manufacturer_path(manufacturer)
    when current_user.admin? then admin_manufacturer_path(manufacturer)
    when current_user.manager? then manager_manufacturer_path(manufacturer)
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
