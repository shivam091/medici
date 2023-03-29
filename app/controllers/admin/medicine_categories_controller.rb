# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::MedicineCategoriesController < Admin::BaseController

  before_action :find_medicine_category, except: [:index, :active, :inactive, :new, :create]
  before_action do
    if action_name.in?(["index", "active", "inactive", "new", "create"])
      authorize ::MedicineCategory
    else
      authorize @medicine_category
    end
  end

  # GET /admin/medicine-categories
  def index
    @medicine_categories = policy_scope(::MedicineCategory).active
    @pagy, @medicine_categories = pagy(@medicine_categories)
  end

  # GET /admin/medicine-categories/active
  def active
    @medicine_categories = policy_scope(::MedicineCategory).active
    @pagy, @medicine_categories = pagy(@medicine_categories)
  end

  # GET /admin/medicine-categories/inactive
  def inactive
    @medicine_categories = policy_scope(::MedicineCategory).inactive
    @pagy, @medicine_categories = pagy(@medicine_categories)
  end

  # GET /admin/medicine-categories/new
  def new
    @medicine_category = ::MedicineCategory.new
  end

  # POST /admin/medicine-categories
  def create
    response = ::MedicineCategories::CreateService.(medicine_category_params)
    @medicine_category = response.payload[:medicine_category]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_medicine_categories_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:medicine_category_form, partial: "admin/medicine_categories/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/medicine-categories/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/medicine-categories/:uuid
  def update
    response = ::MedicineCategories::UpdateService.(@medicine_category, medicine_category_params)
    @medicine_category = response.payload[:medicine_category]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_medicine_categories_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:medicine_category_form, partial: "admin/medicine_categories/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/medicine-categories/:uuid
  def destroy
    response = ::MedicineCategories::DestroyService.(@medicine_category)
    @medicine_category = response.payload[:medicine_category]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_medicine_categories_path
  end

  # PATCH /admin/medicine-categories/:uuid/activate
  def activate
    response = ::MedicineCategories::ActivateService.(@medicine_category)
    @medicine_category = response.payload[:medicine_category]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to inactive_admin_medicine_categories_path
  end

  # PATCH /admin/medicine-categories/:uuid/deactivate
  def deactivate
    response = ::MedicineCategories::DeactivateService.(@medicine_category)
    @medicine_category = response.payload[:medicine_category]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_medicine_categories_path
  end

  private

  def medicine_category_params
    params.require(:medicine_category).permit(
      :name,
      :description,
      :is_active,
    )
  end

  def find_medicine_category
    @medicine_category = policy_scope(::MedicineCategory).find(params.fetch(:uuid))
  end
end
