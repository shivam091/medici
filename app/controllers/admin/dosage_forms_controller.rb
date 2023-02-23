# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::DosageFormsController < Admin::BaseController

  # GET /admin/dosage-forms
  def index
    @dosage_forms = ::DosageForm.active.includes(:currency)
    @pagy, @dosage_forms = pagy(@dosage_forms)
  end
end
