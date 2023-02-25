# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Suppliers::CreateService < ApplicationService
  def initialize(supplier_attributes)
    @supplier_attributes = supplier_attributes.dup
  end

  def call
    create_supplier
  end

  private

  attr_reader :supplier_attributes

  def create_supplier
    supplier = ::Supplier.new(supplier_attributes)
    if supplier.save
      ::ServiceResponse.success(
        message: t("suppliers.create.success", supplier_name: supplier.name),
        payload: {supplier: supplier}
      )
    else
      ::ServiceResponse.error(
        message: t("suppliers.create.error"),
        payload: {supplier: supplier}
      )
    end
  end
end
