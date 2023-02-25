# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::PackingTypesController < Admin::BaseController

  # GET /admin/packing-types
  def index
    @packing_types = ::PackingType.active
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

  private

  def packing_type_params
    params.require(:packing_type).permit(:name, :is_active)
  end
end
