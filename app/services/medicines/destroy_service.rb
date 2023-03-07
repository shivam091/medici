# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicines::DestroyService < ApplicationService
  def initialize(medicine)
    @medicine = medicine
  end

  def call
    destroy_medicine
  end

  private

  attr_reader :medicine

  def destroy_medicine
    if medicine.destroy
      ::ServiceResponse.success(
        message: t("medicines.destroy.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    else
      ::ServiceResponse.error(
        message: t("medicines.destroy.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    end
  end
end
