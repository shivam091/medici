# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/address_spec.rb

require "spec_helper"

RSpec.describe Address, type: :model do
  describe "valid factory" do
    let(:addressable) { create(:admin, :confirmed) }
    it { is_expected.to have_a_valid_factory.with_associations(addressable:) }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "included modules" do
    it { is_expected.to include_module(Sortable) }
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
