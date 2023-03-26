# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.super_admin? || user.admin?)
        scope.all
      elsif (user.manager? || user.cashier?)
        user.expenses
      else
        scope.none
      end
    end
  end

  def index?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def inactive?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def new?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def create?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def edit?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?) && record.pending?
  end

  def update?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?) && record.pending?
  end

  def activate?
    (user.super_admin? || user.admin?)
  end

  def deactivate?
    (user.super_admin? || user.admin?)
  end

  def destroy?
    user.super_admin?
  end
end
