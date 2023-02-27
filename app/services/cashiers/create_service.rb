# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Cashiers::CreateService < ApplicationService
  def initialize(cashier_attributes)
    @cashier_attributes = cashier_attributes.dup
  end

  def call
    create_cashier
  end

  private

  attr_reader :cashier_attributes

  def create_cashier
    cashier = ::Cashier.new(cashier_attributes)
    if cashier.save
      ::ServiceResponse.success(
        message: t("cashiers.create.success", cashier_name: cashier.name),
        payload: {cashier: cashier}
      )
    else
      ::ServiceResponse.error(
        message: t("cashiers.create.error"),
        payload: {cashier: cashier}
      )
    end
  end
end
