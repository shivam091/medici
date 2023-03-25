# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredients::DeactivateService < ApplicationService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    deactivate_ingredient
  end

  private

  attr_reader :ingredient

  def deactivate_ingredient
    if ingredient.deactivate!
      ::ServiceResponse.success(
        message: t("ingredients.deactivate.success", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    else
      ::ServiceResponse.error(
        message: t("ingredients.deactivate.error", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    end
  end
end
