# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customers::DestroyService < ApplicationService
  def initialize(customer)
    @customer = customer
  end

  def call
    destroy_customer
  end

  private

  attr_reader :customer

  def destroy_customer
    if customer.destroy
      ::ServiceResponse.success(
        message: t("customers.destroy.success", customer_name: customer.name),
        payload: {customer: customer}
      )
    else
      ::ServiceResponse.error(
        message: t("customers.destroy.error", customer_name: customer.name),
        payload: {customer: customer}
      )
    end
  end
end
