# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currencies::DestroyService < ApplicationService
  def initialize(currency)
    @currency = currency
  end

  def call
    destroy_currency
  end

  private

  attr_reader :currency

  def destroy_currency
    if currency.destroy
      ::ServiceResponse.success(
        message: t("currencies.destroy.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    else
      ::ServiceResponse.error(
        message: t("currencies.destroy.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    end
  end
end
