# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currencies::DeactivateService < ApplicationService
  def initialize(currency)
    @currency = currency
  end

  def call
    deactivate_currency
  end

  private

  attr_reader :currency

  def deactivate_currency
    if currency.deactivate!
      ::ServiceResponse.success(
        message: t("currencies.deactivate.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    else
      ::ServiceResponse.error(
        message: t("currencies.deactivate.error", currency_name: currency.name),
        payload: {currency: currency}
      )
    end
  end
end
