# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.accessible(user)
    end
  end

  def index?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def pending?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def incomplete?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def received?
    (user.super_admin? || user.admin? || user.manager?)
  end

  def new?
    (user.super_admin? || user.admin?)
  end

  def create?
    (user.super_admin? || user.admin?)
  end

  def edit?
    (user.super_admin? || user.admin?) && !record.received?
  end

  def update?
    (user.super_admin? || user.admin?) && !record.received?
  end

  def destroy?
    (user.super_admin? || user.admin?) && record.pending?
  end
end
