# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::IngredientsController < Admin::BaseController

  # GET /admin/ingredients
  def index
    @ingredients = ::Ingredient.active
    @pagy, @ingredients = pagy(@ingredients)
  end
end
