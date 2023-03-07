# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ReferenceCode
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.instance_eval do
      before_create :set_reference_code
    end
  end

  private

  REFERENCE_CODE_LENGTH = 15.freeze

  REFERENCE_CODE_MAPPINGS = {
    Ingredient: "ING",
    Supplier: "SPLR",
    Manufacturer: "MFGR",
    Medicine: "MED",
    Manager: "MGR",
    Admin: "ADM",
    Cashier: "CAS",
    Customer: "CUST",
    Store: "STR"
  }.with_indifferent_access.freeze

  def set_reference_code
    model = self.class
    relation = if self.respond_to?(:is_active)
      model.unscope(where: :is_active)
    else
      model
    end

    case model.to_s
    when "Ingredient", "Medicine"
      chars = self.name.first(2)
      new_reference_code = REFERENCE_CODE_MAPPINGS[model.to_s] + "-" + chars.upcase
      last_code = relation.where(model.arel_table[:name].matches("#{chars}%")).maximum(:reference_code)
    when "Manufacturer", "Supplier", "Store"
      new_reference_code = REFERENCE_CODE_MAPPINGS[model.to_s] + "-"
      last_code = relation.maximum(:reference_code)
    when "User"
      case
      when self.admin?
        new_reference_code = REFERENCE_CODE_MAPPINGS["Admin"] + "-"
        last_code = relation.admins.maximum(:reference_code)
      when self.manager?
        new_reference_code = REFERENCE_CODE_MAPPINGS["Manager"] + "-"
        last_code = relation.managers.maximum(:reference_code)
      when self.cashier?
        new_reference_code = REFERENCE_CODE_MAPPINGS["Cashier"] + "-"
        last_code = relation.cashiers.maximum(:reference_code)
      end
    end

    new_code = last_code.present? ? (last_code.scan(/\d+/).first.to_i + 1) : 1

    self.reference_code = new_reference_code + new_code.to_s.rjust((REFERENCE_CODE_LENGTH - new_reference_code.length), "0")
  end
end
