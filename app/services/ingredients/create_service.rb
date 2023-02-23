# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ingredients::CreateService < ApplicationService
  def initialize(ingredient_attributes)
    @ingredient_attributes = ingredient_attributes.dup
  end

  def call
    create_ingredient
  end

  private

  attr_reader :ingredient_attributes

  def create_ingredient
    ingredient = ::Ingredient.new(ingredient_attributes)
    if ingredient.save
      ::ServiceResponse.success(
        message: t("ingredients.create.success", ingredient_name: ingredient.name),
        payload: {ingredient: ingredient}
      )
    else
      ::ServiceResponse.error(
        message: t("ingredients.create.error"),
        payload: {ingredient: ingredient}
      )
    end
  end
end
