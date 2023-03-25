# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Suppliers::DeactivateService < ApplicationService
  def initialize(supplier)
    @supplier = supplier
  end

  def call
    deactivate_supplier
  end

  private

  attr_reader :supplier

  def deactivate_supplier
    if supplier.deactivate!
      ::ServiceResponse.success(
        message: t("suppliers.deactivate.success", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    else
      ::ServiceResponse.error(
        message: t("suppliers.deactivate.error", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    end
  end
end
