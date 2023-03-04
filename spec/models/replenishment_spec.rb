# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/replenishment_spec.rb

require "spec_helper"

RSpec.describe Replenishment, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:medicine_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:quantity_pending_from_supplier).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:medicine_id).unique(true) }

    it { is_expected.to have_foreign_key(:medicine_id).with_name(:fk_replenishments_medicine_id_on_medicines).on_delete(:cascade) }

    it { is_expected.to have_check_constraint("chk_13a13af222").with_condition("quantity_pending_from_supplier >= 0") }
    it { is_expected.to have_check_constraint("chk_037df1962d").with_condition("quantity_pending_from_supplier IS NOT NULL") }
  end

  describe "default values" do
    it "should set 0 as default value for #quantity_pending_from_supplier" do
      replenishment = build(:replenishment)
      expect(replenishment.quantity_pending_from_supplier).to eq(0)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:medicine).inverse_of(:replenishment).touch(true) }
  end

  describe "validations" do
    subject { build(:replenishment) }

    describe "#medicine_id" do
      it { is_expected.to validate_presence_of(:medicine_id).with_message("is required") }
    end

    describe "#quantity_pending_from_supplier" do
      it { is_expected.to validate_presence_of(:quantity_pending_from_supplier).with_message("is required") }
      it { is_expected.to validate_numericality_of(:quantity_pending_from_supplier).only_integer }
      it { is_expected.to validate_numericality_of(:quantity_pending_from_supplier).is_greater_than_or_equal_to(0) }
    end
  end
end
