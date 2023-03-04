# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/medicine_supplier_spec.rb

require "spec_helper"

RSpec.describe MedicineSupplier, type: :model do
  describe "valid factory" do
    let(:medicine) { create(:medicine) }
    let(:supplier) { create(:supplier) }

    it { is_expected.to have_a_valid_factory.with_associations({medicine:, supplier:}) }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "default values" do
    it "should set 0 as default value for #total_quantity_supplied" do
      medicine_supplier = build(:medicine_supplier)
      expect(medicine_supplier.total_quantity_supplied).to eq(0)
    end
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:medicine_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:supplier_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:total_quantity_supplied).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:medicine_id) }
    it { is_expected.to have_db_index(:supplier_id) }

    it { is_expected.to have_foreign_key(:medicine_id).with_name(:fk_medicine_suppliers_medicine_id_on_medicines).on_delete(:cascade) }
    it { is_expected.to have_foreign_key(:supplier_id).with_name(:fk_medicine_suppliers_supplier_id_on_suppliers).on_delete(:restrict) }
  end

  describe "validations" do
    describe "#medicine_id" do
      it { is_expected.to validate_presence_of(:medicine_id).with_message("is required") }
    end

    describe "#supplier_id" do
      it { is_expected.to validate_presence_of(:supplier_id).with_message("is required") }
    end

    describe "#total_quantity_supplied" do
      it { is_expected.to validate_presence_of(:total_quantity_supplied).with_message("is required") }
      it { is_expected.to validate_numericality_of(:total_quantity_supplied).only_integer }
      it { is_expected.to validate_numericality_of(:total_quantity_supplied).is_greater_than_or_equal_to(0) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:medicine).inverse_of(:medicine_suppliers).touch(true) }
    it { is_expected.to belong_to(:supplier).inverse_of(:medicine_suppliers) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:email).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:phone_number).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:name).to(:medicine).with_prefix }
  end
end
