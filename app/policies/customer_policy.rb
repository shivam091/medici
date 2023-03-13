# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CustomerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if (user.admin? || user.manager? || user.cashier?)
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    (user.admin? || user.manager? || user.cashier?)
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

  def destroy?
    user.admin?
  end
end
