# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/store_spec.rb

require "spec_helper"

RSpec.describe Store, type: :model do
  subject(:store) { build(:store, :active) }

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
    it { is_expected.to have_db_column(:phone_number).of_type(:string) }
    it { is_expected.to have_db_column(:fax_number).of_type(:string) }
    it { is_expected.to have_db_column(:registration_number).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:phone_number).unique(true) }

    it { is_expected.to have_foreign_key(:currency_id).with_name(:fk_stores_currency_id_on_currencies).on_delete(:restrict) }

    it { is_expected.to have_check_constraint("chk_0966276692").with_condition("char_length(email::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_55cbeaf1bf").with_condition("char_length(fax_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_304d33223a").with_condition("char_length(phone_number::text) <= 32") }
    it { is_expected.to have_check_constraint("chk_fc84f48d5e").with_condition("email IS NOT NULL AND email::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_8f1459e838").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_2d9bb89816").with_condition("phone_number IS NOT NULL AND phone_number::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_48a4cf1224").with_condition("registration_number IS NOT NULL AND registration_number::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_42f8a2c319").with_condition("char_length(reference_code::text) <= 15") }
    it { is_expected.to have_check_constraint("chk_83a023b8df").with_condition("reference_code IS NOT NULL AND reference_code::text <> ''::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      store = build(:store)
      expect(store.is_active).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to belong_to(:currency) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:address).update_only(true) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:country).to(:address) }
    it { is_expected.to delegate_method(:name).to(:country).with_prefix(true).allow_nil }
    it { is_expected.to delegate_method(:name).to(:currency).with_prefix(true) }
    it { is_expected.to delegate_method(:iso_code).to(:currency).with_prefix(true) }
  end

  include_examples "apply default scope on name"

  describe "validations" do
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

    describe "#registration_number" do
      it { is_expected.to validate_presence_of(:registration_number).with_message("is required") }
    end
  end

  describe "instance methods" do
    include_examples "has address"
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of stores for select list" do
        store = create(:store, :active)
        expect(described_class.select_options).to eq([[store.name, store.id]])
      end
    end
  end
end
