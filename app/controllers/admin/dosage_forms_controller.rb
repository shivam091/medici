# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::DosageFormsController < Admin::BaseController

  before_action :find_dosage_form, except: [:index, :new, :create]
  before_action do
    if action_name.in?(["index", "new", "create"])
      authorize ::DosageForm
    else
      authorize @dosage_form
    end
  end

  # GET /admin/dosage-forms
  def index
    @dosage_forms = policy_scope(::DosageForm).active
    @pagy, @dosage_forms = pagy(@dosage_forms)
  end

  # GET /admin/dosage-forms/new
  def new
    @dosage_form = ::DosageForm.new
  end

  # POST /admin/dosage-forms
  def create
    response = ::DosageForms::CreateService.(dosage_form_params)
    @dosage_form = response.payload[:dosage_form]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_dosage_forms_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:dosage_form_form, partial: "admin/dosage_forms/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/dosage-forms/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/dosage-forms/:uuid
  def update
    response = ::DosageForms::UpdateService.(@dosage_form, dosage_form_params)
    @dosage_form = response.payload[:dosage_form]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_dosage_forms_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:dosage_form_form, partial: "admin/dosage_forms/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/dosage-forms/:uuid
  def destroy
    response = ::DosageForms::DestroyService.(@dosage_form)
    @dosage_form = response.payload[:dosage_form]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_dosage_forms_path
  end

  private

  def dosage_form_params
    params.require(:dosage_form).permit(
      :name,
      :is_active,
    )
  end

  def find_dosage_form
    @dosage_form = policy_scope(::DosageForm).find(params.fetch(:uuid))
  end
end
