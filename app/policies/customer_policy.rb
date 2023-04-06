# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CustomerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.admin? || user.manager? || user.cashier?)
        scope.all
      end
    end
  end

  def index?
    (user.admin? || user.manager?)
  end

  def active?
    (user.admin? || user.manager? || user.cashier?)
  end

  def inactive?
    (user.admin? || user.manager?)
  end

  def new?
    (user.admin? || user.manager? || user.cashier?)
  end

  def create?
    (user.admin? || user.manager? || user.cashier?)
  end

  def edit?
    (user.admin? || user.manager? || user.cashier?)
  end

  def update?
    (user.admin? || user.manager? || user.cashier?)
  end

  def activate?
    (user.admin? || user.manager?)
  end

  def deactivate?
    (user.admin? || user.manager?)
  end

  def destroy?
    user.admin?
  end

  def show?
    (user.admin? || user.manager? || user.cashier?)
  end
end
