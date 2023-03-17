# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::ShiftsController < Admin::BaseController

  # GET /admin/shifts
  def index
    @shifts = ::Shift.active
    @pagy, @shifts = pagy(@shifts)
  end
end
