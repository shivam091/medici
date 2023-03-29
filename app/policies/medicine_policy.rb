# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.super_admin? || user.admin? || user.manager?)
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def inactive?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def new?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def create?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def edit?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def update?
    (user.super_admin? || user.admin? || user.manager?)
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
