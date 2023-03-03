# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/manufacturer_spec.rb

require "spec_helper"

RSpec.describe Manufacturer, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Sortable) }
  end

  describe "attributes and indexes" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:phone_number).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:phone_number).unique(true) }

    it { is_expected.to have_check_constraint("chk_a17491f35f").with_condition("char_length(email::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_d3a128b5e4").with_condition("char_length(name::text) <= 110") }
    it { is_expected.to have_check_constraint("chk_1ca5089b5d").with_condition("char_length(phone_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_7601216330").with_condition("email IS NOT NULL AND email::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_64d76cfbb0").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_8a3644299c").with_condition("phone_number IS NOT NULL AND phone_number::text <> ''::text") }
  end

  describe "associations" do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:medicines).dependent(:restrict_with_exception) }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      manufacturer = build(:manufacturer)
      expect(manufacturer.is_active).to be_falsy
    end
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:address).update_only(true) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:country).to(:address) }
    it { is_expected.to delegate_method(:name).to(:country).with_prefix(true) }
  end

  include_examples "apply default scope on name"

  describe "validations" do
    subject { build(:manufacturer, :with_address) }

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

  describe "#address" do
    context "when manufacturer has no address" do
      it "returns new instance of the address" do
        expect(subject.address).to be_a_new(::Address)
      end
    end

    context "when manufacturer has an address" do
      it "returns address of the manufacturer" do
        manufacturer = create(:manufacturer, :with_address)

        expect(manufacturer.address.address1).to eq("New Panvel (E)")
      end
    end
  end

  describe ".select_options" do
    it "should return array of manufacturers for select list" do
      manufacturer = create(:manufacturer, :active)
      expect(described_class.select_options).to eq([[manufacturer.name, manufacturer.id]])
    end
  end
end
