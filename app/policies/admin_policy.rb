# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.super_admin?
  end

  def active?
    user.super_admin?
  end

  def inactive?
    user.super_admin?
  end

  def new?
    user.super_admin?
  end

  def create?
    user.super_admin?
  end

  def edit?
    user.super_admin?
  end

  def update?
    user.super_admin?
  end

  def activate?
    user.super_admin?
  end

  def deactivate?
    user.super_admin?
  end

  def destroy?
    user.super_admin?
  end
end
