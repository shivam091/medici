# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module CustomersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_customer, except: [:index, :new, :create]

      # GET /(admin|manager|cashier)/customers
      def index
        @customers = ::Customer.active.includes(:address)
        @pagy, @customers = pagy(@customers)
      end

      # GET /(admin|manager|cashier)/customers/new
      def new
        @customer = ::Customer.new
      end

      # POST /(admin|manager|cashier)/customers
      def create
        response = ::Customers::CreateService.(customer_params)
        @customer = response.payload[:customer]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.customers_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:customer_form, partial: "customers/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end

      # GET /(admin|manager|cashier)/customers/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager|cashier)/customers/:uuid
      def update
        response = ::Customers::UpdateService.(@customer, customer_params)
        @customer = response.payload[:customer]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.customers_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:customer_form, partial: "customers/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end
    end
  end

  private

  def find_customer
    @customer = ::Customer.find(params.fetch(:uuid))
  end

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :mobile_number,
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
