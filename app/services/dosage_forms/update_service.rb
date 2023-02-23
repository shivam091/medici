# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForms::UpdateService < ApplicationService
  def initialize(dosage_form, dosage_form_attributes)
    @dosage_form = dosage_form
    @dosage_form_attributes = dosage_form_attributes.dup
  end

  def call
    update_dosage_form
  end

  private

  attr_reader :dosage_form, :dosage_form_attributes

  def update_dosage_form
    if dosage_form.update(dosage_form_attributes)
      ::ServiceResponse.success(
        message: t("dosage_forms.update.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    else
      ::ServiceResponse.error(
        message: t("dosage_forms.update.error"),
        payload: {dosage_form: dosage_form}
      )
    end
  end
end
