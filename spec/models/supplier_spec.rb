# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/supplier_spec.rb

require "spec_helper"

RSpec.describe Supplier, type: :model do

  subject(:supplier) { build(:supplier) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(ReferenceCode) }
    it { is_expected.to include_module(Toggleable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reference_code).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:phone_number).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:phone_number).unique(true) }

    it { is_expected.to have_check_constraint("chk_b1c47b4cbe").with_condition("char_length(email::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_427b1088f0").with_condition("char_length(name::text) <= 110") }
    it { is_expected.to have_check_constraint("chk_826f24ed62").with_condition("char_length(phone_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_98cae18516").with_condition("email IS NOT NULL AND email::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_9b9db7504e").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_e5ebd50398").with_condition("phone_number IS NOT NULL AND phone_number::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_0996151ba1").with_condition("char_length(reference_code::text) <= 15") }
    it { is_expected.to have_check_constraint("chk_bda7229b58").with_condition("reference_code IS NOT NULL AND reference_code::text <> ''::text") }
  end

  describe "associations" do
    it { is_expected.to have_one(:address).dependent(:destroy) }

    it { is_expected.to have_many(:medicine_suppliers).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:medicines).through(:medicine_suppliers).source(:medicine).inverse_of(:medicine_suppliers) }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      expect(supplier.is_active).to be_falsy
    end
  end

  describe "callbacks" do
    it { is_expected.to have_callback(:before, :create, :set_reference_code) }
    it { is_expected.to have_callback(:after, :commit, :send_active_suppliers_count) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:address).update_only(true) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:country).to(:address) }
    it { is_expected.to delegate_method(:name).to(:country).with_prefix(true) }
  end

  include_examples "apply default scope on reference code asc"

  describe "validations" do
    describe "#reference_code" do
      it { is_expected.to validate_length_of(:reference_code).is_at_most(15).with_message("is too long (maximum is 15 characters)") }
    end

    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(110).with_message("is too long (maximum is 110 characters)") }
    end

    describe "#email" do
      it { is_expected.to validate_presence_of(:email).with_message("is required") }
      it { is_expected.to validate_length_of(:email).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:email).with_message("is already in use") }
    end

    describe "#phone_number" do
      it { is_expected.to validate_presence_of(:phone_number).with_message("is required") }
      it { is_expected.to validate_length_of(:phone_number).is_at_most(32).with_message("is too long (maximum is 32 characters)") }
      it { is_expected.to validate_uniqueness_of(:phone_number).with_message("is already in use").case_insensitive }
    end
  end

  describe "instance methods" do
    include_examples "has address"

    describe "#set_reference_code" do
      context "when supplier is created" do
        subject { create(:supplier) }

        it "sets reference_code for supplier" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("SPLR-0000000001")
        end
      end
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of suppliers for select list" do
        supplier = create(:supplier, :active)
        expect(described_class.select_options).to eq([[supplier.name, supplier.id]])
      end
    end
  end
end
