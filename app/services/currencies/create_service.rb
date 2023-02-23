# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Currencies::CreateService < ApplicationService
  def initialize(currency_attributes)
    @currency_attributes = currency_attributes.dup
  end

  def call
    create_currency
  end

  private

  attr_reader :currency_attributes

  def create_currency
    currency = ::Currency.new(currency_attributes)
    if currency.save
      ::ServiceResponse.success(
        message: t("currencies.create.success", currency_name: currency.name),
        payload: {currency: currency}
      )
    else
      ::ServiceResponse.error(
        message: t("currencies.create.error"),
        payload: {currency: currency}
      )
    end
  end
end
