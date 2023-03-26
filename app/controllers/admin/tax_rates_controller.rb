# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::TaxRatesController < Admin::BaseController

  # GET /admin/tax-rates
  def index
    @tax_rates = policy_scope(::TaxRate).includes(:country)
    @pagy, @tax_rates = pagy(@tax_rates)
  end

  # GET /admin/tax-rates/new
  def new
    @tax_rate = ::TaxRate.new
  end

  # POST /admin/tax-rates
  def create
    response = ::TaxRates::CreateService.(tax_rate_params)
    @tax_rate = response.payload[:tax_rate]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_tax_rates_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:tax_rate_form, partial: "admin/tax_rates/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def tax_rate_params
    params.require(:tax_rate).permit(:country_id, :type, :rate)
  end
end
