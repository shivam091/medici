# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredients::ActivateService < ApplicationService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    activate_ingredient
  end

  private

  attr_reader :ingredient

  def activate_ingredient
    if ingredient.activate!
      ::ServiceResponse.success(
        message: t("ingredients.activate.success", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    else
      ::ServiceResponse.error(
        message: t("ingredients.activate.error", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    end
  end
end
