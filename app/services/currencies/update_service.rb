# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currencies::UpdateService < ApplicationService
  def initialize(currency, currency_attributes)
    @currency = currency
    @currency_attributes = currency_attributes.dup
  end

  def call
    update_currency
  end

  private

  attr_reader :currency, :currency_attributes

  def update_currency
    if currency.update(currency_attributes)
      ::ServiceResponse.success(
        message: t("currencies.update.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    else
      ::ServiceResponse.error(
        message: t("currencies.update.error"),
        payload: {currency: currency}
      )
    end
  end
end
