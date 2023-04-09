# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expenses::RejectService < ApplicationService
  def initialize(expense)
    @expense = expense
  end

  def call
    reject_expense
  end

  private

  attr_reader :expense

  def reject_expense
    if expense.reject!
      ::ServiceResponse.success(
        message: t("expenses.reject.success"),
        payload: {expense: expense}
      )
    else
      ::ServiceResponse.error(
        message: t("expenses.reject.error"),
        payload: {expense: expense}
      )
    end
  end
end
