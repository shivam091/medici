# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Medicines::CreateService < ApplicationService
  def initialize(user, medicine_attributes)
    @user = user
    @medicine_attributes = medicine_attributes.dup
  end

  def call
    create_medicine
  end

  private

  attr_reader :user, :medicine_attributes

  def create_medicine
    medicine = user.medicines.build(medicine_attributes)
    if medicine.save
      ::ServiceResponse.success(
        message: t("medicines.create.success", medicine_name: medicine.name, medicine_code: medicine.reference_code),
        payload: {medicine: medicine}
      )
    else
      ::ServiceResponse.error(
        message: t("medicines.create.error"),
        payload: {medicine: medicine}
      )
    end
  end
end
