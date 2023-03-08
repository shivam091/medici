# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customers::UpdateService < ApplicationService
  def initialize(customer, customer_attributes)
    @customer = customer
    @customer_attributes = customer_attributes.dup
  end

  def call
    update_customer
  end

  private

  attr_reader :customer, :customer_attributes

  def update_customer
    if customer.update(customer_attributes)
      ::ServiceResponse.success(
        message: t("customers.update.success", customer_name: customer.name),
        payload: {customer: customer}
      )
    else
      ::ServiceResponse.error(
        message: t("customers.update.error"),
        payload: {customer: customer}
      )
    end
  end
end
