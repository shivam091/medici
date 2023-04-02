# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class StorePolicy < SuperAdminPolicy
  def show?
    (user.super_admin? || user.admin?)
  end
end
