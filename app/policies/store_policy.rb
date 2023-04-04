# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class StorePolicy < AdminPolicy
  def show?
    user.super_admin?
  end
end
