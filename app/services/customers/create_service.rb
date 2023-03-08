# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Customers::CreateService < ApplicationService
  def initialize(customer_attributes)
    @customer_attributes = customer_attributes.dup
  end

  def call
    create_customer
  end

  private

  attr_reader :customer_attributes

  def create_customer
    customer = ::Customer.new(customer_attributes)
    if customer.save
      ::ServiceResponse.success(
        message: t("customers.create.success", customer_name: customer.name),
        payload: {customer: customer}
      )
    else
      ::ServiceResponse.error(
        message: t("customers.create.error"),
        payload: {customer: customer}
      )
    end
  end
end
