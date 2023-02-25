# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Suppliers::UpdateService < ApplicationService
  def initialize(supplier, supplier_attributes)
    @supplier = supplier
    @supplier_attributes = supplier_attributes.dup
  end

  def call
    update_supplier
  end

  private

  attr_reader :supplier, :supplier_attributes

  def update_supplier
    if supplier.update(supplier_attributes)
      ::ServiceResponse.success(
        message: t("suppliers.update.success", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    else
      ::ServiceResponse.error(
        message: t("suppliers.update.error"),
        payload: {supplier: supplier}
      )
    end
  end
end
