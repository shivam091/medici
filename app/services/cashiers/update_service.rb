# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Cashiers::UpdateService < ApplicationService
  def initialize(cashier, cashier_attributes)
    @cashier = cashier
    @cashier_attributes = cashier_attributes.dup
  end

  def call
    update_cashier
  end

  private

  attr_reader :cashier, :cashier_attributes

  def update_cashier
    if cashier.update(cashier_attributes)
      ::ServiceResponse.success(
        message: t("cashiers.update.success", cashier_name: cashier.name),
        payload: {cashier: cashier}
      )
    else
      ::ServiceResponse.error(
        message: t("cashiers.update.error"),
        payload: {cashier: cashier}
      )
    end
  end
end
