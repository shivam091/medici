# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.accessible(user)
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
    (user.admin? || user.manager?)
  end

  def create?
    (user.admin? || user.manager?)
  end

  def edit?
    (user.admin? || user.manager?)
  end

  def update?
    (user.admin? || user.manager?)
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

  def import?
    user.admin?
  end
end
