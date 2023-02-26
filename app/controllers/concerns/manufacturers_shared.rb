# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ManufacturersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager)/manufacturers
      def index
        @manufacturers = ::Manufacturer.active.includes(:address)
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
    end
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
