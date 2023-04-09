# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expenses::ApproveService < ApplicationService
  def initialize(expense)
    @expense = expense
  end

  def call
    approve_expense
  end

  private

  attr_reader :expense

  def approve_expense
    if expense.approve!
      ::ServiceResponse.success(
        message: t("expenses.approve.success"),
        payload: {expense: expense}
      )
    else
      ::ServiceResponse.error(
        message: t("expenses.approve.error"),
        payload: {expense: expense}
      )
    end
  end
end
