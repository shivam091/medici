# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class DosageForms::DestroyService < ApplicationService
  def initialize(dosage_form)
    @dosage_form = dosage_form
  end

  def call
    destroy_dosage_form
  end

  private

  attr_reader :dosage_form

  def destroy_dosage_form
    if dosage_form.destroy
      ::ServiceResponse.success(
        message: t("dosage_forms.destroy.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    else
      ::ServiceResponse.error(
        message: t("dosage_forms.destroy.success", dosage_form_name: dosage_form.name),
        payload: {dosage_form: dosage_form}
      )
    end
  end
end
