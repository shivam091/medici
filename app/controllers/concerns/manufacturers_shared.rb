# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ManufacturersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_manufacturer, except: [:index, :active, :inactive, :new, :create]
      before_action do
        if action_name.in?(["index", "active", "inactive", "new", "create"])
          authorize ::Manufacturer
        else
          authorize @manufacturer
        end
      end

      # GET /(admin|manager)/manufacturers
      def index
        @manufacturers = policy_scope(::Manufacturer).including_address
        @pagy, @manufacturers = pagy(@manufacturers)
      end

      # GET /(admin|manager)/manufacturers/active
      def active
        @manufacturers = policy_scope(::Manufacturer).active.including_address
        @pagy, @manufacturers = pagy(@manufacturers)
      end

      # GET /(admin|manager)/manufacturers/inactive
      def inactive
        @manufacturers = policy_scope(::Manufacturer).inactive.including_address
        @pagy, @manufacturers = pagy(@manufacturers)
      end

      # GET /(admin|manager)/manufacturers/new
      def new
        @manufacturer = ::Manufacturer.new
      end

      # POST /(admin|manager)/manufacturers
      def create
        response = ::Manufacturers::CreateService.(manufacturer_params)
        @manufacturer = response.payload[:manufacturer]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.manufacturers_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:manufacturer_form, partial: "manufacturers/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end

      # GET /(admin|manager)/manufacturers/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager)/manufacturers/:uuid
      def update
        response = ::Manufacturers::UpdateService.(@manufacturer, manufacturer_params)
        @manufacturer = response.payload[:manufacturer]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.manufacturers_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:manufacturer_form, partial: "manufacturers/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end

      # GET /(admin|manager)/manufacturers/:uuid
      def show
      end

      # DELETE /(admin|manager)/manufacturers/:uuid
      def destroy
        response = ::Manufacturers::DestroyService.(@manufacturer)
        @manufacturer = response.payload[:manufacturer]
        if response.success?
          flash[:info] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.manufacturers_path
      end

      # PATCH /admin/manufacturers/:uuid/activate
      def activate
        response = ::Manufacturers::ActivateService.(@manufacturer)
        @manufacturer = response.payload[:manufacturer]
        if response.success?
          flash[:notice] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.inactive_manufacturers_path
      end

      # PATCH /admin/manufacturer/:uuid/deactivate
      def deactivate
        response = ::Manufacturers::DeactivateService.(@manufacturer)
        @manufacturer = response.payload[:manufacturer]
        if response.success?
          flash[:warning] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.manufacturers_path
      end
    end
  end

  private

  def find_manufacturer
    @manufacturer = policy_scope(::Manufacturer).find(params.fetch(:uuid))
  end

  def manufacturer_params
    params.require(:manufacturer).permit(
      :name,
      :email,
      :phone_number,
      :customer_care_number,
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
