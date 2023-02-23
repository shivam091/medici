# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicineCategories::CreateService < ApplicationService
  def initialize(medicine_category_attributes)
    @medicine_category_attributes = medicine_category_attributes.dup
  end

  def call
    create_medicine_category
  end

  private

  attr_reader :medicine_category_attributes

  def create_medicine_category
    medicine_category = ::MedicineCategory.new(medicine_category_attributes)
    if medicine_category.save
      ::ServiceResponse.success(
        message: t("medicine_categories.create.success", medicine_category_name: medicine_category.name),
        payload: {medicine_category: medicine_category}
      )
    else
      ::ServiceResponse.error(
        message: t("medicine_categories.create.error"),
        payload: {medicine_category: medicine_category}
      )
    end
  end
end
