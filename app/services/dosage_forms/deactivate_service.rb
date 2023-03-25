# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForms::DeactivateService < ApplicationService
  def initialize(dosage_form)
    @dosage_form = dosage_form
  end

  def call
    deactivate_dosage_form
  end

  private

  attr_reader :dosage_form

  def deactivate_dosage_form
    if dosage_form.deactivate!
      ::ServiceResponse.success(
        message: t("dosage_forms.deactivate.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    else
      ::ServiceResponse.error(
        message: t("dosage_forms.deactivate.error", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    end
  end
end
