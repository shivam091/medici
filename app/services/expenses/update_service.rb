# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Expenses::UpdateService < ApplicationService
  def initialize(expense, expense_attributes)
    @expense = expense
    @expense_attributes = expense_attributes.dup
  end

  def call
    update_expense
  end

  private

  attr_reader :expense, :expense_attributes

  def update_expense
    if expense.update(expense_attributes)
      ::ServiceResponse.success(
        message: t("expenses.update.success"),
        payload: {expense: expense}
      )
    else
      ::ServiceResponse.error(
        message: t("expenses.update.error"),
        payload: {expense: expense}
      )
    end
  end
end
