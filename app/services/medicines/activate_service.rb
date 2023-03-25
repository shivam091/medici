# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicines::ActivateService < ApplicationService
  def initialize(medicine)
    @medicine = medicine
  end

  def call
    activate_medicine
  end

  private

  attr_reader :medicine

  def activate_medicine
    if medicine.activate!
      ::ServiceResponse.success(
        message: t("medicines.activate.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    else
      ::ServiceResponse.error(
        message: t("medicines.activate.error"),
        payload: {medicine: medicine}
      )
    end
  end
end
