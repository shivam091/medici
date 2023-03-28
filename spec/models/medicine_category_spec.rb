# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/medicine_category_spec.rb

require "spec_helper"

RSpec.describe MedicineCategory, type: :model do

  subject(:medicine_category) { build(:medicine_category) }

  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  it_behaves_like "subclass of ApplicationRecord"

  describe "included modules" do
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(Filterable) }
    it { is_expected.to include_module(Toggleable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:is_active) }

    it { is_expected.to have_check_constraint("chk_03e39c141b").with_condition("char_length(name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_fc60a64610").with_condition("name IS NOT NULL AND name::text <> ''::text") }
    it { is_expected.to have_check_constraint("chk_563b95552d").with_condition("char_length(description::text) <= 255") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      expect(medicine_category.is_active).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:medicines).dependent(:restrict_with_exception) }
  end

  describe "validations" do
    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:name).with_message("is already in use") }
    end

    describe "#description" do
      it do
        is_expected.to validate_length_of(:description)
                         .is_at_most(255)
                         .allow_blank
                         .allow_nil
                         .with_message("is too long (maximum is 255 characters)")
      end
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of dosage forms for select list" do
        medicine_category = create(:medicine_category, :active)
        expect(described_class.select_options).to eq([[medicine_category.name, medicine_category.id]])
      end
    end
  end
end
