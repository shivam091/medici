# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CurrenciesController < Admin::BaseController

  before_action :find_currency, except: [:index, :inactive, :new, :create]
  before_action do
    if action_name.in?(["index", "inactive", "new", "create"])
      authorize ::Currency
    else
      authorize @currency
    end
  end

  # GET /admin/currencies
  def index
    @currencies = policy_scope(::Currency).active.includes(:countries)
    @pagy, @currencies = pagy(@currencies)
  end

  # GET /admin/currencies/inactive
  def inactive
    @currencies = policy_scope(::Currency).inactive.includes(:countries)
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

  # PATCH /admin/currencies/:uuid/activate
  def activate
    response = ::Currencies::ActivateService.(@currency)
    @currency = response.payload[:currency]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to inactive_admin_currencies_path
  end

  # PATCH /admin/currencies/:uuid/deactivate
  def deactivate
    response = ::Currencies::DeactivateService.(@currency)
    @currency = response.payload[:currency]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_currencies_path
  end

  private

  def find_currency
    @currency = policy_scope(::Currency).find(params.fetch(:uuid))
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
