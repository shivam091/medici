# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicines::DeactivateService < ApplicationService
  def initialize(medicine)
    @medicine = medicine
  end

  def call
    deactivate_medicine
  end

  private

  attr_reader :medicine

  def deactivate_medicine
    if medicine.deactivate!
      ::ServiceResponse.success(
        message: t("medicines.deactivate.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    else
      ::ServiceResponse.error(
        message: t("medicines.deactivate.error"),
        payload: {medicine: medicine}
      )
    end
  end
end
