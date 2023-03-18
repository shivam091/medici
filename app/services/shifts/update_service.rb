# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shifts::UpdateService < ApplicationService
  def initialize(shift, shift_attributes)
    @shift = shift
    @shift_attributes = shift_attributes.dup
  end

  def call
    update_shift
  end

  private

  attr_reader :shift, :shift_attributes

  def update_shift
    if shift.update(shift_attributes)
      ::ServiceResponse.success(
        message: t("shifts.update.success", shift_name: shift.name),
        payload: {shift: shift}
      )
    else
      ::ServiceResponse.error(
        message: t("shifts.update.error"),
        payload: {shift: shift}
      )
    end
  end
end
