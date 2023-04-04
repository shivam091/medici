# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPolicy < AdminPolicy
  def banned?
    user.super_admin?
  end
end
