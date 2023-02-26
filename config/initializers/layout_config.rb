# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Medici::Application.configure do
  config.to_prepare do
    User::SessionsController.layout          "devise"

    Admin::BaseController.layout             "admin"
    Admin::SuppliersController.layout        "admin"
    Admin::ManufacturersController.layout    "admin"

    Cashier::BaseController.layout           "cashier"

    Manager::BaseController.layout           "manager"
    Manager::SuppliersController.layout      "manager"
    Manager::ManufacturersController.layout  "manager"
  end
end
