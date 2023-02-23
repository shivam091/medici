# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CurrenciesController < Admin::BaseController

  # GET /admin/currencies
  def index
    @currencies = ::Currency.active.includes(:countries)
    @pagy, @currencies = pagy(@currencies)
  end
end
