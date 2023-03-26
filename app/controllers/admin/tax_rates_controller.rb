# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::TaxRatesController < Admin::BaseController

  # GET /admin/tax-rates
  def index
    @tax_rates = policy_scope(::TaxRate)
    @pagy, @tax_rates = pagy(@tax_rates)
  end
end
