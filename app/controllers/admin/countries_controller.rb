# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CountriesController < Admin::BaseController

  before_action :find_country, except: [:index, :active, :inactive, :new, :create]
  before_action do
    if action_name.in?(["index", "active", "inactive", "new", "create"])
      authorize ::Country
    else
      authorize @country
    end
  end

  # GET /admin/countries
  def index
    @countries = policy_scope(::Country).active.includes(:currency)
    @pagy, @countries = pagy(@countries)
  end

  # GET /admin/countries/active
  def active
    @countries = policy_scope(::Country).active.includes(:currency)
    @pagy, @countries = pagy(@countries)
  end

  # GET /admin/countries/inactive
  def inactive
    @countries = policy_scope(::Country).inactive.includes(:currency)
    @pagy, @countries = pagy(@countries)
  end

  # GET /admin/countries/new
  def new
    @country = ::Country.new
  end

  # POST /admin/countries
  def create
    response = ::Countries::CreateService.(country_params)
    @country = response.payload[:country]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_countries_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:country_form, partial: "admin/countries/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/countries/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/countries/:uuid
  def update
    response = ::Countries::UpdateService.(@country, country_params)
    @country = response.payload[:country]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_countries_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:country_form, partial: "admin/countries/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/countries/:uuid
  def destroy
    response = ::Countries::DestroyService.(@country)
    @country = response.payload[:country]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_countries_path
  end

  # PATCH /admin/countries/:uuid/activate
  def activate
    response = ::Countries::ActivateService.(@country)
    @country = response.payload[:country]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to inactive_admin_countries_path
  end

  # PATCH /admin/countries/:uuid/deactivate
  def deactivate
    response = ::Countries::DeactivateService.(@country)
    @country = response.payload[:country]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_countries_path
  end

  private

  def country_params
    params.require(:country).permit(
      :name,
      :iso2,
      :iso3,
      :calling_code,
      :has_postal_code,
      :is_active,
      :currency_id
    )
  end

  def find_country
    @country = policy_scope(::Country).find(params.fetch(:uuid))
  end
end
