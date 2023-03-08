# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module CustomersHelper
  def customers_path
    case
    when current_user.admin? then admin_customers_path
    when current_user.manager? then manager_customers_path
    when current_user.cashier? then cashier_customers_path
    end
  end

  def new_customer_path
    case
    when current_user.admin? then new_admin_customer_path
    when current_user.manager? then new_manager_customer_path
    when current_user.cashier? then new_cashier_customer_path
    end
  end

  def edit_customer_path(customer)
    case
    when current_user.admin? then edit_admin_customer_path(customer)
    when current_user.manager? then edit_manager_customer_path(customer)
    when current_user.cashier? then edit_cashier_customer_path(customer)
    end
  end

  def customer_path(customer)
    case
    when current_user.admin? then admin_customer_path(customer)
    when current_user.manager? then manager_customer_path(customer)
    when current_user.cashier? then cashier_customer_path(customer)
    end
  end

  def customer_object(customer)
    case
    when current_user.admin? then [:admin, customer]
    when current_user.manager? then [:manager, customer]
    when current_user.cashier? then [:cashier, customer]
    end
  end
end
