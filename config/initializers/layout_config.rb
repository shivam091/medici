# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Medici::Application.configure do
  config.to_prepare do
    User::SessionsController.layout            "devise"

    Cashier::BaseController.layout             "cashier"
    Cashier::ProfilesController.layout         "cashier"
    Cashier::CustomersController.layout        "cashier"
    Cashier::ExpensesController.layout         "cashier"

    Admin::BaseController.layout               "admin"
    Admin::SuppliersController.layout          "admin"
    Admin::ManufacturersController.layout      "admin"
    Admin::MedicinesController.layout          "admin"
    Admin::ProfilesController.layout           "admin"
    Admin::CustomersController.layout          "admin"
    Admin::ExpensesController.layout           "admin"
    Admin::PurchaseOrdersController.layout     "admin"

    Manager::BaseController.layout             "manager"
    Manager::SuppliersController.layout        "manager"
    Manager::ManufacturersController.layout    "manager"
    Manager::MedicinesController.layout        "manager"
    Manager::ProfilesController.layout         "manager"
    Manager::CustomersController.layout        "manager"
    Manager::ExpensesController.layout         "manager"
    Manager::PurchaseOrdersController.layout   "manager"
  end
end
