# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Cashiers::DestroyService < ApplicationService
  def initialize(cashier)
    @cashier = cashier
  end

  def call
    destroy_cashier
  end

  private

  attr_reader :cashier

  def destroy_cashier
    if cashier.destroy
      ::ServiceResponse.success(
        message: t("cashiers.destroy.success", cashier_name: cashier.name),
        payload: {cashier: cashier}
      )
    else
      ::ServiceResponse.error(
        message: t("cashiers.destroy.success", cashier_name: cashier.name),
        payload: {cashier: cashier}
      )
    end
  end
end
