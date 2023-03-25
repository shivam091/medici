# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Suppliers::ActivateService < ApplicationService
  def initialize(supplier)
    @supplier = supplier
  end

  def call
    activate_supplier
  end

  private

  attr_reader :supplier

  def activate_supplier
    if supplier.activate!
      ::ServiceResponse.success(
        message: t("suppliers.activate.success", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    else
      ::ServiceResponse.error(
        message: t("suppliers.activate.error", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    end
  end
end
