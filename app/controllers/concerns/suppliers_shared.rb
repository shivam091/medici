# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module SuppliersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager)/suppliers
      def index
        @suppliers = ::Supplier.active.includes(:address)
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
                turbo_stream.update(:supplier_form, partial: "admin/suppliers/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end
    end
  end

  private

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
