# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/address_spec.rb

require "spec_helper"

RSpec.describe Address, type: :model do

  let(:addressable) { create(:admin, :confirmed) }
  subject(:address) { build(:address, addressable:) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory.with_associations(addressable:) }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "included modules" do
    it { is_expected.to include_module(Sortable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:country_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:addressable_type).of_type(:string) }
    it { is_expected.to have_db_column(:addressable_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:address1).of_type(:string) }
    it { is_expected.to have_db_column(:address2).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:region).of_type(:string) }
    it { is_expected.to have_db_column(:postal_code).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index([:addressable_type, :addressable_id]) }
    it { is_expected.to have_db_index(:country_id) }

    it { is_expected.to have_foreign_key(:country_id).with_name(:fk_addresses_country_id_on_countries).on_delete(:restrict) }

    it { is_expected.to have_check_constraint("chk_dd06263840").with_condition("address1 IS NOT NULL AND address1::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_764e04cfbe").with_condition("addressable_id IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_d04b2c3c0f").with_condition("addressable_type IS NOT NULL") }
    it { is_expected.to have_check_constraint("chk_79a0b55f17").with_condition("char_length(address1::text) <= 100") }
    it { is_expected.to have_check_constraint("chk_9d9af86e34").with_condition("char_length(address2::text) <= 100") }
    it { is_expected.to have_check_constraint("chk_fc9ec5eb57").with_condition("char_length(city::text) <= 100") }
    it { is_expected.to have_check_constraint("chk_39c4bcf78a").with_condition("char_length(postal_code::text) <= 20") }
    it { is_expected.to have_check_constraint("chk_26dd3e9819").with_condition("char_length(region::text) <= 100") }
    it { is_expected.to have_check_constraint("chk_6c705ebe2e").with_condition("city IS NOT NULL AND city::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_f7e0314437").with_condition("country_id IS NOT NULL") }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:country).with_prefix(true) }
    it { is_expected.to delegate_method(:iso2).to(:country).with_prefix(true) }
    it { is_expected.to delegate_method(:iso3).to(:country).with_prefix(true) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:addressable).optional }
    it { is_expected.to belong_to(:country).inverse_of(:addresses) }
  end

  describe "validations" do
    describe "#address1" do
      it { is_expected.to validate_presence_of(:address1).with_message("is required") }
      it { is_expected.to validate_length_of(:address1).is_at_most(100).with_message("is too long (maximum is 100 characters)") }
    end

    describe "#address2" do
      it { is_expected.to validate_length_of(:address2).is_at_most(100).allow_nil.allow_blank.with_message("is too long (maximum is 100 characters)") }
    end

    describe "#city" do
      it { is_expected.to validate_presence_of(:city).with_message("is required") }
      it { is_expected.to validate_length_of(:city).is_at_most(100).with_message("is too long (maximum is 100 characters)") }
    end

    describe "#region" do
      it { is_expected.to validate_length_of(:region).is_at_most(100).allow_nil.allow_blank.with_message("is too long (maximum is 100 characters)") }
    end

    describe "#postal_code" do
      it { is_expected.to validate_length_of(:postal_code).is_at_most(20).allow_nil.allow_blank.with_message("is too long (maximum is 20 characters)") }
    end

    describe "#country_id" do
      it { is_expected.to validate_presence_of(:country_id).with_message("is required") }
    end
  end

  include_examples "apply default scope on created_at desc"
end
