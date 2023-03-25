# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module SuppliersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_supplier, except: [:index, :inactive, :new, :create]
      before_action do
        if action_name.in?(["index", "inactive", "new", "create"])
          authorize ::Supplier
        else
          authorize @supplier
        end
      end

      # GET /(admin|manager)/suppliers
      def index
        @suppliers = policy_scope(::Supplier).active.includes(:address)
        @pagy, @suppliers = pagy(@suppliers)
      end

      # GET /(admin|manager)/suppliers/inactive
      def inactive
        @suppliers = policy_scope(::Supplier).inactive.includes(:address)
        @pagy, @suppliers = pagy(@suppliers)
      end

      # GET /(admin|manager)/suppliers/new
      def new
        @supplier = ::Supplier.new
      end

      # POST /(admin|manager)/suppliers
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

      # GET /(admin|manager)/suppliers/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager)/suppliers/:uuid
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

      # DELETE /(admin|manager)/suppliers/:uuid
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

      # PATCH /admin/suppliers/:uuid/activate
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

      # PATCH /admin/supplier/:uuid/deactivate
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
    end
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
