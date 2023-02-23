# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::MedicineCategoriesController < Admin::BaseController

  before_action :find_medicine_category, except: [:index, :new, :create]

  # GET /admin/medicine-categories
  def index
    @medicine_categories = ::MedicineCategory.active
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

  private

  def medicine_category_params
    params.require(:medicine_category).permit(
      :name,
      :description,
      :is_active,
    )
  end

  def find_medicine_category
    @medicine_category = ::MedicineCategory.find(params.fetch(:uuid))
  end
end
