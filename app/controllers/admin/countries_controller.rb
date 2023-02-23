# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CountriesController < Admin::BaseController

  before_action :find_country, except: [:index, :new, :create]

  # GET /admin/countries
  def index
    @countries = ::Country.active.includes(:currency)
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
    @country = ::Country.find(params.fetch(:uuid))
  end
end
