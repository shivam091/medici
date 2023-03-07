# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::StoresController < Admin::BaseController

  before_action :find_store, except: [:index, :new, :create]

  # GET /admin/stores
  def index
    @stores = ::Store.active.includes(:address)
    @pagy, @stores = pagy(@stores)
  end

  # GET /admin/stores/new
  def new
    @store = ::Store.new
  end

  # POST /(admin|manager)/stores
  def create
    response = ::Stores::CreateService.(store_params)
    @store = response.payload[:store]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_stores_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:store_form, partial: "admin/stores/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/stores/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/stores/:uuid
  def update
    response = ::Stores::UpdateService.(@store, store_params)
    @store = response.payload[:store]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_stores_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:store_form, partial: "admin/stores/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/stores/:uuid
  def destroy
    response = ::Stores::DestroyService.(@store)
    @store = response.payload[:store]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_stores_path
  end

  private

  def find_store
    @store = ::Store.find(params.fetch(:uuid))
  end

  def store_params
    params.require(:store).permit(
      :name,
      :email,
      :phone_number,
      :registration_number,
      :fax_number,
      :is_active,
      :currency_id,
      address_attributes: [
        :address1,
        :address2,
        :city,
        :region,
        :country_id,
        :postal_code
      ]
    )
  end
end
