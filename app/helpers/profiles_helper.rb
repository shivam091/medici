# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ProfilesHelper
  def edit_profile_path
    case
    when current_user.admin? then edit_admin_profile_path
    when current_user.manager? then edit_manager_profile_path
    when current_user.cashier? then edit_cashier_profile_path
    end
  end

  def profile_path
    case
    when current_user.admin? then admin_profile_path
    when current_user.manager? then manager_profile_path
    when current_user.cashier? then cashier_profile_path
    end
  end

  def user_form_model
    case
    when current_user.admin? then [:admin, current_user]
    when current_user.manager? then [:manager, current_user]
    when current_user.cashier? then [:cashier, current_user]
    end
  end
end
