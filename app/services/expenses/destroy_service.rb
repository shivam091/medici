# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expenses::DestroyService < ApplicationService
  def initialize(expense)
    @expense = expense
  end

  def call
    destroy_expense
  end

  private

  attr_reader :expense

  def destroy_expense
    if expense.destroy
      ::ServiceResponse.success(
        message: t("expenses.destroy.success"),
        payload: {expense: expense}
      )
    else
      ::ServiceResponse.error(
        message: t("expenses.destroy.error"),
        payload: {expense: expense}
      )
    end
  end
end
