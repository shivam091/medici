# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/country_spec.rb

require "spec_helper"

RSpec.describe Country, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Toggleable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:iso2).of_type(:string) }
    it { is_expected.to have_db_column(:iso3).of_type(:string) }
    it { is_expected.to have_db_column(:calling_code).of_type(:string) }
    it { is_expected.to have_db_column(:has_postal_code).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:currency_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:iso2).unique(true) }
    it { is_expected.to have_db_index(:iso3).unique(true) }
    it { is_expected.to have_db_index(:currency_id).unique(false) }
    it { is_expected.to have_db_index(:is_active) }

    it { is_expected.to have_foreign_key(:currency_id).with_name(:fk_countries_currency_id_on_currencies).on_delete(:restrict) }

    it { is_expected.to have_check_constraint("chk_1e56054f5a").with_condition("char_length(iso2::text) = 2") }
    it { is_expected.to have_check_constraint("chk_291f18a38d").with_condition("char_length(iso3::text) = 3") }
    it { is_expected.to have_check_constraint("chk_68ab57466f").with_condition("char_length(name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_940fe1eee7").with_condition("currency_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_b1bf328063").with_condition("iso2 IS NOT NULL AND iso2::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_87680983ee").with_condition("iso3 IS NOT NULL AND iso3::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_03b9f57701").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_91b43fb014").with_condition("upper(iso2::text) = iso2::text") }
    it { is_expected.to have_check_constraint("chk_915d162f3f").with_condition("upper(iso3::text) = iso3::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      country = build(:country)
      expect(country.is_active).to be_falsy
    end

    it "should set false as default value for #has_postal_code" do
      country = build(:country)
      expect(country.has_postal_code).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_one(:tax_rate).dependent(:restrict_with_exception) }
    it { is_expected.to have_one(:discount).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:addresses).dependent(:restrict_with_exception) }
    it { is_expected.to belong_to(:currency).inverse_of(:countries) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:currency).with_prefix(true) }
  end

  describe "default scope" do
    it "should apply default scope on #iso2" do
      expect(described_class.all.to_sql).to eq described_class.all.order(iso2: :asc).to_sql
    end
  end

  describe "validations" do
    subject { build(:country) }

    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:name).with_message("is already in use") }
    end

    describe "#iso2" do
      it { is_expected.to validate_presence_of(:iso2).with_message("is required") }
      it { is_expected.to validate_length_of(:iso2).is_equal_to(2) }
      it { is_expected.to validate_uniqueness_of(:iso2).with_message("is already in use") }
      it { is_expected.to allow_value("IN").for(:iso2) }
      it { is_expected.not_to allow_value("INR").for(:iso2).with_message("must be exactly 2 characters long") }
      it { is_expected.not_to allow_value("in").for(:iso2).with_message("must be in uppercase") }
    end

    describe "#iso3" do
      it { is_expected.to validate_presence_of(:iso3).with_message("is required") }
      it { is_expected.to validate_length_of(:iso3).is_equal_to(3) }
      it { is_expected.to validate_uniqueness_of(:iso3).with_message("is already in use") }
      it { is_expected.to allow_value("INR").for(:iso3) }
      it { is_expected.not_to allow_value("IN").for(:iso3).with_message("must be exactly 3 characters long") }
      it { is_expected.not_to allow_value("inr").for(:iso3).with_message("must be in uppercase") }
    end

    describe "#calling_code" do
      it { is_expected.to validate_presence_of(:calling_code).with_message("is required") }
      it { is_expected.to validate_length_of(:calling_code).is_at_least(2).with_message("is too short (minimum is 2 characters)") }
      it { is_expected.to validate_length_of(:calling_code).is_at_most(10).with_message("is too long (maximum is 10 characters)") }
    end

    describe "#currency_id" do
      it { is_expected.to validate_presence_of(:currency_id).with_message("is required") }
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of countries for select list" do
        country = create(:country, :active)
        expect(described_class.select_options).to eq([[country.name, country.id]])
      end
    end
  end
end
