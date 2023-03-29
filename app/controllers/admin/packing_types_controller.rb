# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::PackingTypesController < Admin::BaseController

  before_action :find_packing_type, except: [:index, :active, :inactive, :new, :create]
  before_action do
    if action_name.in?(["index", "active", "inactive", "new", "create"])
      authorize ::PackingType
    else
      authorize @packing_type
    end
  end

  # GET /admin/packing-types
  def index
    @packing_types = policy_scope(::PackingType).active
    @pagy, @packing_types = pagy(@packing_types)
  end

  # GET /admin/packing-types/active
  def active
    @packing_types = policy_scope(::PackingType).active
    @pagy, @packing_types = pagy(@packing_types)
  end

  # GET /admin/packing-types/inactive
  def inactive
    @packing_types = policy_scope(::PackingType).inactive
    @pagy, @packing_types = pagy(@packing_types)
  end

  # GET /admin/packing-types/new
  def new
    @packing_type = ::PackingType.new
  end

  # POST /admin/packing-types
  def create
    response = ::PackingTypes::CreateService.(packing_type_params)
    @packing_type = response.payload[:packing_type]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_packing_types_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:packing_type_form, partial: "admin/packing_types/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/packing-types/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/packing-types/:uuid
  def update
    response = ::PackingTypes::UpdateService.(@packing_type, packing_type_params)
    @packing_type = response.payload[:packing_type]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_packing_types_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:packing_type_form, partial: "admin/packing_types/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/packing-types/:uuid
  def destroy
    response = ::PackingTypes::DestroyService.(@packing_type)
    @packing_type = response.payload[:packing_type]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_packing_types_path
  end

  # PATCH /admin/packing-types/:uuid/activate
  def activate
    response = ::PackingTypes::ActivateService.(@packing_type)
    @packing_type = response.payload[:packing_type]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to inactive_admin_packing_types_path
  end

  # PATCH /admin/packing-types/:uuid/deactivate
  def deactivate
    response = ::PackingTypes::DeactivateService.(@packing_type)
    @packing_type = response.payload[:packing_type]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_packing_types_path
  end

  private

  def packing_type_params
    params.require(:packing_type).permit(:name, :is_active)
  end

  def find_packing_type
    @packing_type = policy_scope(::PackingType).find(params.fetch(:uuid))
  end
end
