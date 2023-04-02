# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPolicy < SuperAdminPolicy
  def banned?
    user.super_admin?
  end
end
