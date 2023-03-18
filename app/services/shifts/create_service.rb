# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Shifts::CreateService < ApplicationService
  def initialize(shift_attributes)
    @shift_attributes = shift_attributes.dup
  end

  def call
    create_shift
  end

  private

  attr_reader :shift_attributes

  def create_shift
    shift = ::Shift.new(shift_attributes)
    if shift.save
      ::ServiceResponse.success(
        message: t("shifts.create.success", shift_name: shift.name),
        payload: {shift: shift}
      )
    else
      ::ServiceResponse.error(
        message: t("shifts.create.error"),
        payload: {shift: shift}
      )
    end
  end
end
