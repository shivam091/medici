# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customers::ActivateService < ApplicationService
  def initialize(customer)
    @customer = customer
  end

  def call
    activate_customer
  end

  private

  attr_reader :customer

  def activate_customer
    if customer.activate!
      ::ServiceResponse.success(
        message: t("customers.activate.success", customer_name: customer.name),
        payload: {customer: customer}
      )
    else
      ::ServiceResponse.error(
        message: t("customers.activate.error", customer_name: customer.name),
        payload: {customer: customer}
      )
    end
  end
end
