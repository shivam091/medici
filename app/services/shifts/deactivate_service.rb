# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shifts::DeactivateService < ApplicationService
  def initialize(shift)
    @shift = shift
  end

  def call
    deactivate_shift
  end

  private

  attr_reader :shift

  def deactivate_shift
    if shift.deactivate!
      ::ServiceResponse.success(
        message: t("shifts.deactivate.success", shift_name: shift.name),
        payload: {shift: shift}
      )
    else
      ::ServiceResponse.error(
        message: t("shifts.deactivate.error", shift_name: shift.name),
        payload: {shift: shift}
      )
    end
  end
end
