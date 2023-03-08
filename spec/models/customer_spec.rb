# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/customer_spec.rb

require "spec_helper"

RSpec.describe Customer, type: :model do
  subject(:customer) { build(:customer) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(ReferenceCode) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reference_code).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:mobile_number).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:mobile_number).unique(true) }

    it { is_expected.to have_check_constraint("chk_9b044dc5bd").with_condition("char_length(email::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_8c988d796e").with_condition("char_length(name::text) <= 110") }
    it { is_expected.to have_check_constraint("chk_3ae00196cf").with_condition("char_length(mobile_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_7344bc8336").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_ee6ddadabe").with_condition("mobile_number IS NOT NULL AND mobile_number::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_92e8724169").with_condition("char_length(reference_code::text) <= 15") }
    it { is_expected.to have_check_constraint("chk_cc9fd06e9d").with_condition("reference_code IS NOT NULL AND reference_code::text <> ''::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      expect(customer.is_active).to be_falsy
    end
  end

  describe "callbacks" do
    it { is_expected.to have_callback(:before, :create, :set_reference_code) }
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
      it { is_expected.to validate_length_of(:email).allow_nil.allow_blank.is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:email).with_message("is already in use") }
    end

    describe "#mobile_number" do
      it { is_expected.to validate_presence_of(:mobile_number).with_message("is required") }
      it { is_expected.to validate_length_of(:mobile_number).is_at_most(32).with_message("is too long (maximum is 32 characters)") }
      it { is_expected.to validate_uniqueness_of(:mobile_number).with_message("is already in use").case_insensitive }
    end
  end

  describe "instance methods" do
    include_examples "has address"

    describe "#set_reference_code" do
      context "when customer is created" do
        subject { create(:customer) }

        it "sets reference_code for customer" do
          expect(subject.reference_code).to be_present
          expect(subject.reference_code).to eq("CUST-0000000001")
        end
      end
    end
  end
end
