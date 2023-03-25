# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customers::DeactivateService < ApplicationService
  def initialize(customer)
    @customer = customer
  end

  def call
    deactivate_customer
  end

  private

  attr_reader :customer

  def deactivate_customer
    if customer.deactivate!
      ::ServiceResponse.success(
        message: t("customers.deactivate.success", customer_name: customer.name),
        payload: {customer: customer}
      )
    else
      ::ServiceResponse.error(
        message: t("customers.deactivate.error", customer_name: customer.name),
        payload: {customer: customer}
      )
    end
  end
end
