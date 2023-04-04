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
    (user.admin? || user.manager?)
  end

  def pending?
    (user.admin? || user.manager?)
  end

  def incomplete?
    (user.admin? || user.manager?)
  end

  def received?
    (user.admin? || user.manager?)
  end

  def new?
    (user.admin? || user.manager?)
  end

  def create?
    (user.admin? || user.manager?)
  end

  def edit?
    (user.admin? && !record.received?)
  end

  def update?
    (user.admin? && !record.received?)
  end

  def destroy?
    (user.admin? && record.pending?)
  end

  def mark_as_received?
    (user.admin? && !record.received?)
  end
end
