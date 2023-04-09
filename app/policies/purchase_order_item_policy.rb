# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PurchaseOrderItemPolicy < ApplicationPolicy
  def edit?
    (user.admin? || user.manager?) && !record.purchase_order.received?
  end

  def update?
    (user.admin? || user.manager?) && !record.purchase_order.received?
  end

  def destroy?
    (user.admin? && record.purchase_order.pending?)
  end
end
