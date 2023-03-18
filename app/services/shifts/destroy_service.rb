# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shifts::DestroyService < ApplicationService
  def initialize(shift)
    @shift = shift
  end

  def call
    destroy_shift
  end

  private

  attr_reader :shift

  def destroy_shift
    if shift.destroy
      ::ServiceResponse.success(
        message: t("shifts.destroy.success", shift_name: shift.name),
        payload: {shift: shift}
      )
    else
      ::ServiceResponse.error(
        message: t("shifts.destroy.error", shift_name: shift.name),
        payload: {shift: shift}
      )
    end
  end
end
