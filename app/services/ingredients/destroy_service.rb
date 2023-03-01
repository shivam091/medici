# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredients::DestroyService < ApplicationService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    destroy_ingredient
  end

  private

  attr_reader :ingredient

  def destroy_ingredient
    if ingredient.destroy
      ::ServiceResponse.success(
        message: t("ingredients.destroy.success", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    else
      ::ServiceResponse.error(
        message: t("ingredients.destroy.error", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    end
  end
end
