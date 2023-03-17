# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::ShiftsController < Admin::BaseController

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

  private

  def shift_params
    params.require(:shift).permit(:name, :starts_at, :ends_at, :is_active)
  end
end
