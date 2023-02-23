# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForms::CreateService < ApplicationService
  def initialize(dosage_form_attributes)
    @dosage_form_attributes = dosage_form_attributes.dup
  end

  def call
    create_dosage_form
  end

  private

  attr_reader :dosage_form_attributes

  def create_dosage_form
    dosage_form = ::DosageForm.new(dosage_form_attributes)
    if dosage_form.save
      ::ServiceResponse.success(
        message: t("dosage_forms.create.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    else
      ::ServiceResponse.error(
        message: t("dosage_forms.create.error"),
        payload: {dosage_form: dosage_form}
      )
    end
  end
end
