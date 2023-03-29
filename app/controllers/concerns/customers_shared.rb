# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module CustomersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_customer, except: [:index, :active, :inactive, :new, :create]
      before_action do
        if action_name.in?(["index", "active", "inactive", "new", "create"])
          authorize ::Customer
        else
          authorize @customer
        end
      end

      # GET /(admin|manager|cashier)/customers
      def index
        @customers = policy_scope(::Customer).includes(:address)
        @pagy, @customers = pagy(@customers)
      end

      # GET /(admin|manager|cashier)/customers/active
      def active
        @customers = policy_scope(::Customer).active.includes(:address)
        @pagy, @customers = pagy(@customers)
      end

      # GET /(admin|manager|cashier)/customers/inactive
      def inactive
        @customers = policy_scope(::Customer).inactive.includes(:address)
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

      # DELETE /(admin|manager|cashier)/customers/:uuid
      def destroy
        response = ::Customers::DestroyService.(@customer)
        @customer = response.payload[:customer]
        if response.success?
          flash[:info] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.customers_path
      end

      # PATCH /admin/customers/:uuid/activate
      def activate
        response = ::Customers::ActivateService.(@customer)
        @customer = response.payload[:customer]
        if response.success?
          flash[:notice] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.inactive_customers_path
      end

      # PATCH /admin/customer/:uuid/deactivate
      def deactivate
        response = ::Customers::DeactivateService.(@customer)
        @customer = response.payload[:customer]
        if response.success?
          flash[:warning] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.customers_path
      end
    end
  end

  private

  def find_customer
    @customer = policy_scope(::Customer).find(params.fetch(:uuid))
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
