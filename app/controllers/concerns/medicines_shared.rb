# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MedicinesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      before_action :find_medicine, except: [:index, :active, :inactive, :new, :create]
      before_action do
        if action_name.in?(["index", "active", "inactive", "new", "create"])
          authorize ::Medicine
        else
          authorize @medicine
        end
      end

      # GET /(admin|manager)/medicines
      def index
        @medicines = policy_scope(::Medicine).includes(:stock, :replenishment)
        @pagy, @medicines = pagy(@medicines)
      end

      # GET /(admin|manager)/medicines/active
      def active
        @medicines = policy_scope(::Medicine).active.includes(:stock, :replenishment)
        @pagy, @medicines = pagy(@medicines)
      end

      # GET /(admin|manager)/medicines/inactive
      def inactive
        @medicines = policy_scope(::Medicine).inactive.includes(:stock, :replenishment)
        @pagy, @medicines = pagy(@medicines)
      end

      # GET /(admin|manager)/medicines/new
      def new
        @medicine = ::Medicine.new
      end

      # POST /(admin|manager)/medicines
      def create
        response = ::Medicines::CreateService.(current_user, medicine_params)
        @medicine = response.payload[:medicine]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.medicines_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:medicine_form, partial: "medicines/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end

      # GET /(admin|manager)/medicines/:uuid/edit
      def edit
      end

      # PUT/PATCH /(admin|manager)/medicines/:uuid
      def update
        response = ::Medicines::UpdateService.(@medicine, medicine_params)
        @medicine = response.payload[:medicine]
        if response.success?
          flash[:notice] = response.message
          redirect_to helpers.medicines_path
        else
          flash.now[:alert] = response.message
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.update(:medicine_form, partial: "medicines/form"),
                render_flash
              ], status: :unprocessable_entity
            end
          end
        end
      end

      # DELETE /(admin|manager)/medicines/:uuid
      def destroy
        response = ::Medicines::DestroyService.(@medicine)
        @medicine = response.payload[:medicine]
        if response.success?
          flash[:info] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.medicines_path
      end

      # PATCH /admin/medicines/:uuid/activate
      def activate
        response = ::Medicines::ActivateService.(@medicine)
        @medicine = response.payload[:medicine]
        if response.success?
          flash[:notice] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.inactive_medicines_path
      end

      # PATCH /admin/medicines/:uuid/deactivate
      def deactivate
        response = ::Medicines::DeactivateService.(@medicine)
        @medicine = response.payload[:medicine]
        if response.success?
          flash[:warning] = response.message
        else
          flash[:alert] = response.message
        end
        redirect_to helpers.medicines_path
      end
    end
  end

  private

  def find_medicine
    @medicine = policy_scope(::Medicine).find(params.fetch(:uuid))
  end

  def medicine_params
    params.require(:medicine).permit(
      :medicine_category_id,
      :dosage_form_id,
      :packing_type_id,
      :manufacturer_id,
      :code,
      :name,
      :description,
      :batch_number,
      :purchase_price,
      :sell_price,
      :manufacture_date,
      :expiry_date,
      :proprietary_name,
      :strength,
      :uom,
      :pack_size,
      :therapeutic_areas,
      :is_active,
      supplier_ids: [],
      medicine_ingredients_attributes: [
        :id,
        :_destroy,
        :ingredient_id,
        :active,
        :strength,
        :uom
      ]
    )
  end
end
