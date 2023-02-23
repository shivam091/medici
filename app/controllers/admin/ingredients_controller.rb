# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::IngredientsController < Admin::BaseController

  # GET /admin/ingredients
  def index
    @ingredients = ::Ingredient.active
    @pagy, @ingredients = pagy(@ingredients)
  end

  # GET /admin/ingredients/new
  def new
    @ingredient = ::Ingredient.new
  end

  # POST /admin/ingredients
  def create
    response = ::Ingredients::CreateService.(ingredient_params)
    @ingredient = response.payload[:ingredient]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_ingredients_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:ingredient_form, partial: "admin/ingredients/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(
      :name,
      :description,
      :is_active,
    )
  end
end
