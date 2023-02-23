# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineCategories::UpdateService < ApplicationService
  def initialize(medicine_category, medicine_category_attributes)
    @medicine_category = medicine_category
    @medicine_category_attributes = medicine_category_attributes.dup
  end

  def call
    update_medicine_category
  end

  private

  attr_reader :medicine_category, :medicine_category_attributes

  def update_medicine_category
    if medicine_category.update(medicine_category_attributes)
      ::ServiceResponse.success(
        message: t("medicine_categories.update.success", medicine_category_name: medicine_category.name),
        payload: {medicine_category: medicine_category}
      )
    else
      ::ServiceResponse.error(
        message: t("medicine_categories.update.error"),
        payload: {medicine_category: medicine_category}
      )
    end
  end
end
