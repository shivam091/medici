# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currencies::ActivateService < ApplicationService
  def initialize(currency)
    @currency = currency
  end

  def call
    activate_currency
  end

  private

  attr_reader :currency

  def activate_currency
    if currency.activate!
      ::ServiceResponse.success(
        message: t("currencies.activate.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    else
      ::ServiceResponse.error(
        message: t("currencies.activate.error", currency_name: currency.name),
        payload: {currency: currency}
      )
    end
  end
end
