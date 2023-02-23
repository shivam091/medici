# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredients::UpdateService < ApplicationService
  def initialize(ingredient, ingredient_attributes)
    @ingredient = ingredient
    @ingredient_attributes = ingredient_attributes.dup
  end

  def call
    update_ingredient
  end

  private

  attr_reader :ingredient, :ingredient_attributes

  def update_ingredient
    if ingredient.update(ingredient_attributes)
      ::ServiceResponse.success(
        message: t("ingredients.update.success", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    else
      ::ServiceResponse.error(
        message: t("ingredients.update.error"),
        payload: {ingredient: ingredient}
      )
    end
  end
end
