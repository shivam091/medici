# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.accessible(user)
    end
  end

  def index?
    (user.admin? || user.manager? || user.cashier?)
  end

  def pending?
    (user.admin? || user.manager? || user.cashier?)
  end

  def approved?
    (user.admin? || user.manager? || user.cashier?)
  end

  def rejected?
    (user.admin? || user.manager? || user.cashier?)
  end

  def new?
    (user.admin? || user.manager? || user.cashier?)
  end

  def create?
    (user.admin? || user.manager? || user.cashier?)
  end

  def edit?
    (user.admin? || user.manager? || user.cashier?) && record.pending?
  end

  def update?
    (user.admin? || user.manager? || user.cashier?) && record.pending?
  end

  def destroy?
    user.admin?
  end

  def approve?
    (user.admin? || user.manager?) && record.pending?
  end

  def reject?
    (user.admin? || user.manager?) && record.pending?
  end
end
