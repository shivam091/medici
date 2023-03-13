# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Suppliers::DestroyService < ApplicationService
  def initialize(supplier)
    @supplier = supplier
  end

  def call
    destroy_supplier
  end

  private

  attr_reader :supplier

  def destroy_supplier
    if supplier.destroy
      ::ServiceResponse.success(
        message: t("suppliers.destroy.success", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    else
      ::ServiceResponse.error(
        message: t("suppliers.destroy.error", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    end
  end
end
