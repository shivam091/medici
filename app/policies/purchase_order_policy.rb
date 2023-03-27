# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.super_admin? || user.admin?)
        scope.all
      elsif user.manager?
        user.purchase_orders
      else
        scope.none
      end
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

  def destroy?
    user.super_admin?
  end
end
