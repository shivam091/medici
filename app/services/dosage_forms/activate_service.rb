# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForms::ActivateService < ApplicationService
  def initialize(dosage_form)
    @dosage_form = dosage_form
  end

  def call
    activate_dosage_form
  end

  private

  attr_reader :dosage_form

  def activate_dosage_form
    if dosage_form.activate!
      ::ServiceResponse.success(
        message: t("dosage_forms.activate.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    else
      ::ServiceResponse.error(
        message: t("dosage_forms.activate.error", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    end
  end
end
