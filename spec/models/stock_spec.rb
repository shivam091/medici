# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/stock_spec.rb

require "spec_helper"

RSpec.describe Stock, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:medicine_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:quantity_in_hand).of_type(:integer).with_options(default: 0) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:medicine_id).unique(true) }

    it { is_expected.to have_foreign_key(:medicine_id).with_name(:fk_stocks_medicine_id_on_medicines).on_delete(:cascade) }

    it { is_expected.to have_check_constraint("chk_f5833a0a29").with_condition("quantity_in_hand >= 0") }
    it { is_expected.to have_check_constraint("chk_07ed382b70").with_condition("quantity_in_hand IS NOT NULL") }
  end

  describe "default values" do
    it "should set 0 as default value for #quantity_in_hand" do
      stock = build(:stock)
      expect(stock.quantity_in_hand).to eq(0)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:medicine).inverse_of(:stock).touch(true) }
  end

  describe "validations" do
    subject { build(:stock) }

    describe "#medicine_id" do
      it { is_expected.to validate_presence_of(:medicine_id).with_message("is required") }
    end

    describe "#quantity_in_hand" do
      it { is_expected.to validate_presence_of(:quantity_in_hand).with_message("is required") }
      it { is_expected.to validate_numericality_of(:quantity_in_hand).only_integer }
      it { is_expected.to validate_numericality_of(:quantity_in_hand).is_greater_than_or_equal_to(0) }
    end
  end
end
