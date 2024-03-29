# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class SuppliersController < ApplicationController
  before_action :find_supplier, except: [:index, :active, :inactive, :new, :create]
  before_action do
    if action_name.in?(["index", "active", "inactive", "new", "create"])
      authorize ::Supplier
    else
      authorize @supplier
    end
  end

  # GET /(:role)/suppliers
  def index
    @suppliers = policy_scope(::Supplier).including_address
    @pagy, @suppliers = pagy(@suppliers)
  end

  # GET /(:role)/suppliers/active
  def active
    @suppliers = policy_scope(::Supplier).active.including_address
    @pagy, @suppliers = pagy(@suppliers)
  end

  # GET /(:role)/suppliers/inactive
  def inactive
    @suppliers = policy_scope(::Supplier).inactive.including_address
    @pagy, @suppliers = pagy(@suppliers)
  end

  # GET /(:role)/suppliers/new
  def new
    @supplier = ::Supplier.new
  end

  # POST /(:role)/suppliers
  def create
    response = ::Suppliers::CreateService.(supplier_params)
    @supplier = response.payload[:supplier]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.suppliers_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:supplier_form, partial: "suppliers/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/suppliers/:uuid/edit
  def edit
  end

  # PUT/PATCH /(:role)/suppliers/:uuid
  def update
    response = ::Suppliers::UpdateService.(@supplier, supplier_params)
    @supplier = response.payload[:supplier]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.suppliers_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:supplier_form, partial: "suppliers/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/suppliers/:uuid
  def show
  end

  # DELETE /(:role)/suppliers/:uuid
  def destroy
    response = ::Suppliers::DestroyService.(@supplier)
    @supplier = response.payload[:supplier]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end

    redirect_to helpers.suppliers_path
  end

  # PATCH /(:role)/suppliers/:uuid/activate
  def activate
    response = ::Suppliers::ActivateService.(@supplier)
    @supplier = response.payload[:supplier]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end

    redirect_to helpers.inactive_suppliers_path
  end

  # PATCH /(:role)/supplier/:uuid/deactivate
  def deactivate
    response = ::Suppliers::DeactivateService.(@supplier)
    @supplier = response.payload[:supplier]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end

    redirect_to helpers.suppliers_path
  end

  private

  def find_supplier
    @supplier = policy_scope(::Supplier).find(params.fetch(:uuid))
  end

  def supplier_params
    params.require(:supplier).permit(
      :name,
      :email,
      :phone_number,
      :is_active,
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
