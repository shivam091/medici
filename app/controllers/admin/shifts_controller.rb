# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::ShiftsController < Admin::BaseController

  before_action :find_shift, except: [:index, :new, :create]

  # GET /admin/shifts
  def index
    @shifts = ::Shift.active
    @pagy, @shifts = pagy(@shifts)
  end

  # GET /admin/shifts/new
  def new
    @shift = ::Shift.new
  end

  # POST /admin/shifts
  def create
    response = ::Shifts::CreateService.(shift_params)
    @shift = response.payload[:shift]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_shifts_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:shift_form, partial: "admin/shifts/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/shifts/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/shifts/:uuid
  def update
    response = ::Shifts::UpdateService.(@shift, shift_params)
    @shift = response.payload[:shift]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_shifts_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:shift_form, partial: "admin/shifts/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/shifts/:uuid
  def destroy
    response = ::Shifts::DestroyService.(@shift)
    @shift = response.payload[:shift]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_shifts_path
  end

  private

  def shift_params
    params.require(:shift).permit(:name, :starts_at, :ends_at, :is_active)
  end

  def find_shift
    @shift = ::Shift.find(params.fetch(:uuid))
  end
end
