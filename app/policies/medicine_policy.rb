# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class MedicinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? || user.manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.manager?
  end

  def new?
    user.admin? || user.manager?
  end

  def create?
    user.admin? || user.manager?
  end

  def edit?
    user.admin? || user.manager?
  end

  def update?
    user.admin? || user.manager?
  end

  def destroy?
    user.admin?
  end
end
