# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineCategories::DeactivateService < ApplicationService
  def initialize(medicine_category)
    @medicine_category = medicine_category
  end

  def call
    deactivate_medicine_category
  end

  private

  attr_reader :medicine_category

  def deactivate_medicine_category
    if medicine_category.deactivate!
      ::ServiceResponse.success(
        message: t("medicine_categories.deactivate.success", medicine_category_name: medicine_category.name),
        payload: {medicine_category: medicine_category}
      )
    else
      ::ServiceResponse.error(
        message: t("medicine_categories.deactivate.error", medicine_category_name: medicine_category.name),
        payload: {medicine_category: medicine_category}
      )
    end
  end
end
