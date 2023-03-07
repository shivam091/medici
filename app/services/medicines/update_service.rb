# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicines::UpdateService < ApplicationService
  def initialize(medicine, medicine_attributes)
    @medicine = medicine
    @medicine_attributes = medicine_attributes.dup
  end

  def call
    update_medicine
  end

  private

  attr_reader :medicine, :medicine_attributes

  def update_medicine
    if medicine.update(medicine_attributes)
      ::ServiceResponse.success(
        message: t("medicines.update.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    else
      ::ServiceResponse.error(
        message: t("medicines.update.error"),
        payload: {medicine: medicine}
      )
    end
  end
end
