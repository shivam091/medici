# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/currency_spec.rb

require "spec_helper"

RSpec.describe Currency, type: :model do

  subject(:currency) { build(:currency) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Filterable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:iso_code).of_type(:string) }
    it { is_expected.to have_db_column(:symbol).of_type(:string) }
    it { is_expected.to have_db_column(:subunit).of_type(:string) }
    it { is_expected.to have_db_column(:subunit_to_unit).of_type(:integer) }
    it { is_expected.to have_db_column(:symbol_first).of_type(:boolean) }
    it { is_expected.to have_db_column(:decimal_mark).of_type(:string) }
    it { is_expected.to have_db_column(:thousands_separator).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:iso_code).unique(true) }

    it { is_expected.to have_check_constraint("chk_67f7771463").with_condition("char_length(decimal_mark::text) = 1") }
    it { is_expected.to have_check_constraint("chk_61a2c44427").with_condition("char_length(iso_code::text) = 3") }
    it { is_expected.to have_check_constraint("chk_1dd815c813").with_condition("char_length(name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_9cdc5548c1").with_condition("char_length(thousands_separator::text) = 1") }
    it { is_expected.to have_check_constraint("chk_cbd3b74101").with_condition("decimal_mark IS NOT NULL AND decimal_mark::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_b9da1bf950").with_condition("iso_code IS NOT NULL AND iso_code::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_9df5dbe3a5").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_9051c710f3").with_condition("symbol IS NOT NULL AND symbol::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_879dba1f31").with_condition("thousands_separator IS NOT NULL AND thousands_separator::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_63e9b93f93").with_condition("upper(iso_code::text) = iso_code::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      expect(currency.is_active).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:countries).dependent(:nullify) }
    it { is_expected.to have_many(:stores).dependent(:restrict_with_exception) }
  end

  describe "default scope" do
    it "should apply default scope on #iso_code" do
      expect(described_class.all.to_sql).to eq described_class.all.order(iso_code: :asc).to_sql
    end
  end

  describe "validations" do
    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:name).with_message("is already in use") }
    end

    describe "#iso_code" do
      it { is_expected.to validate_presence_of(:iso_code).with_message("is required") }
      it { is_expected.to validate_length_of(:iso_code).is_equal_to(3) }
      it { is_expected.to validate_uniqueness_of(:iso_code).with_message("is already in use") }
      it { is_expected.to allow_value("INR").for(:iso_code) }
      it { is_expected.not_to allow_value("IN").for(:iso_code).with_message("must be exactly 3 characters long") }
      it { is_expected.not_to allow_value("inr").for(:iso_code).with_message("must be in uppercase") }
    end

    describe "#symbol" do
      it { is_expected.to validate_presence_of(:symbol).with_message("is required") }
    end

    describe "#subunit_to_unit" do
      it { is_expected.to validate_presence_of(:subunit_to_unit).with_message("is required") }
      it { is_expected.to validate_numericality_of(:subunit_to_unit).only_integer }
      it { is_expected.to allow_value("100").for(:subunit_to_unit) }
      it { is_expected.not_to allow_value("abc").for(:subunit_to_unit).with_message("must be a number") }
    end

    describe "#thousands_separator" do
      it { is_expected.to validate_presence_of(:thousands_separator).with_message("is required") }
      it { is_expected.to allow_value(",").for(:thousands_separator) }
      it { is_expected.to allow_value(".").for(:thousands_separator) }
      it { is_expected.not_to allow_value("A").for(:thousands_separator).with_message("is not included in the list") }
      it { is_expected.to validate_inclusion_of(:thousands_separator).in_array([".", ","]) }
    end

    describe "#decimal_mark" do
      it { is_expected.to validate_presence_of(:decimal_mark).with_message("is required") }
      it { is_expected.to allow_value(",").for(:decimal_mark) }
      it { is_expected.to allow_value(".").for(:decimal_mark) }
      it { is_expected.to validate_inclusion_of(:decimal_mark).in_array([".", ","]) }
      it { is_expected.not_to allow_value("A").for(:decimal_mark).with_message("is not included in the list") }
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of currencies for select list" do
        currency = create(:currency, :active)
        expect(described_class.select_options).to eq([["#{currency.name} (#{currency.symbol})", currency.id]])
      end
    end
  end
end
