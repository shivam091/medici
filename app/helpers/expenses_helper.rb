# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ExpensesHelper
  def expenses_path
    case
    when current_user.super_admin? then admin_expenses_path
    when current_user.admin? then admin_expenses_path
    when current_user.manager? then manager_expenses_path
    when current_user.cashier? then cashier_expenses_path
    end
  end

  def new_expense_path
    case
    when current_user.super_admin? then new_admin_expense_path
    when current_user.admin? then new_admin_expense_path
    when current_user.manager? then new_manager_expense_path
    when current_user.cashier? then new_cashier_expense_path
    end
  end

  def edit_expense_path(expense)
    case
    when current_user.super_admin? then edit_admin_expense_path(expense)
    when current_user.admin? then edit_admin_expense_path(expense)
    when current_user.manager? then edit_manager_expense_path(expense)
    when current_user.cashier? then edit_cashier_expense_path(expense)
    end
  end

  def expense_path(expense)
    case
    when current_user.super_admin? then admin_expense_path(expense)
    when current_user.admin? then admin_expense_path(expense)
    when current_user.manager? then manager_expense_path(expense)
    when current_user.cashier? then cashier_expense_path(expense)
    end
  end

  def expense_object(expense)
    case
    when current_user.super_admin? then [:admin, expense]
    when current_user.admin? then [:admin, expense]
    when current_user.manager? then [:manager, expense]
    when current_user.cashier? then [:cashier, expense]
    end
  end
end
