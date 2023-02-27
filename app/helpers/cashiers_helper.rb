# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module CashiersHelper
  def cashiers_path
    case
    when current_user.admin? then admin_cashiers_path
    when current_user.manager? then manager_cashiers_path
    end
  end

  def new_cashier_path
    case
    when current_user.admin? then new_admin_cashier_path
    when current_user.manager? then new_manager_cashier_path
    end
  end

  def edit_cashier_path(cashier)
    case
    when current_user.admin? then edit_admin_cashier_path(cashier)
    when current_user.manager? then edit_manager_cashier_path(cashier)
    end
  end

  def cashier_path(cashier)
    case
    when current_user.admin? then admin_cashier_path(cashier)
    when current_user.manager? then manager_cashier_path(cashier)
    end
  end
end
