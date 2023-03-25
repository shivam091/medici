# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shifts::ActivateService < ApplicationService
  def initialize(shift)
    @shift = shift
  end

  def call
    activate_shift
  end

  private

  attr_reader :shift

  def activate_shift
    if shift.activate!
      ::ServiceResponse.success(
        message: t("shifts.activate.success", shift_name: shift.name),
        payload: {shift: shift}
      )
    else
      ::ServiceResponse.error(
        message: t("shifts.activate.error", shift_name: shift.name),
        payload: {shift: shift}
      )
    end
  end
end
