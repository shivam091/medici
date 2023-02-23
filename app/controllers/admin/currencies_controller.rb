# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CurrenciesController < Admin::BaseController

  before_action :find_currency, except: [:index, :new, :create]

  # GET /admin/currencies
  def index
    @currencies = ::Currency.active.includes(:countries)
    @pagy, @currencies = pagy(@currencies)
  end

  # GET /admin/currencies/new
  def new
    @currency = ::Currency.new
  end

  # POST /admin/currencies
  def create
    response = ::Currencies::CreateService.(currency_params)
    @currency = response.payload[:currency]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_currencies_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:currency_form, partial: "admin/currencies/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/currencies/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/currencies/:uuid
  def update
    response = ::Currencies::UpdateService.(@currency, currency_params)
    @currency = response.payload[:currency]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_currencies_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:currency_form, partial: "admin/currencies/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/currencies/:uuid
  def destroy
    response = ::Currencies::DestroyService.(@currency)
    @currency = response.payload[:currency]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_currencies_path
  end

  private

  def find_currency
    @currency = ::Currency.find(params.fetch(:uuid))
  end

  def currency_params
    params.require(:currency).permit(
      :name,
      :iso_code,
      :symbol,
      :subunit,
      :subunit_to_unit,
      :html_entity,
      :symbol_first,
      :decimal_mark,
      :thousands_separator,
      :is_active,
      country_ids: []
    )
  end
end
