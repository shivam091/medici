# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/medicine_supplier_spec.rb

require "spec_helper"

RSpec.describe MedicineSupplier, type: :model do

  subject(:medicine_supplier) { build(:medicine_supplier) }

  describe "valid factory" do
    let(:medicine) { create(:medicine, :with_user) }
    let(:supplier) { create(:supplier) }

    it { is_expected.to have_a_valid_factory.with_associations({medicine:, supplier:}) }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "default values" do
    it "should set 0 as default value for #total_quantity_supplied" do
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
    it { is_expected.to have_db_index(:store_id) }

    it { is_expected.to have_foreign_key(:medicine_id).with_name(:fk_medicine_suppliers_medicine_id_on_medicines).on_delete(:cascade) }
    it { is_expected.to have_foreign_key(:supplier_id).with_name(:fk_medicine_suppliers_supplier_id_on_suppliers).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:store_id).with_name(:fk_medicine_suppliers_store_id_on_stores).on_delete(:cascade) }

    it { is_expected.to have_check_constraint("chk_fe78cbf5f6").with_condition("medicine_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_c03bbc37c0").with_condition("store_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_a1e7c5a927").with_condition("supplier_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_fde59c4d35").with_condition("total_quantity_supplied >= 0") }
    it { is_expected.to have_check_constraint("chk_95cd4feefd").with_condition("total_quantity_supplied IS NOT NULL") }
  end

  describe "validations" do
    describe "#medicine_id" do
      it { is_expected.to validate_presence_of(:medicine_id).on(:update).with_message("is required") }
    end

    describe "#store_id" do
      it { is_expected.to validate_presence_of(:store_id).on(:update).with_message("is required") }
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

  describe "callbacks" do
    it { is_expected.to have_callback(:before, :save, :set_store) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:medicine).inverse_of(:medicine_suppliers).touch(true) }
    it { is_expected.to belong_to(:supplier).inverse_of(:medicine_suppliers) }
    it { is_expected.to belong_to(:store).inverse_of(:medicine_suppliers).optional }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:email).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:phone_number).to(:supplier).with_prefix }
    it { is_expected.to delegate_method(:name).to(:medicine).with_prefix }
  end
end
