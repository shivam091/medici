# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CustomerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.super_admin? || user.admin? || user.manager? || user.cashier?)
        scope.all
      end
    end
  end

  def index?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def active?
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
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end

  def update?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
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

  def show?
    (user.super_admin? || user.admin? || user.manager? || user.cashier?)
  end
end
