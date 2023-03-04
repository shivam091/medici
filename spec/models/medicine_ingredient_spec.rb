# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/medicine_ingredient_spec.rb

require "spec_helper"

RSpec.describe MedicineIngredient, type: :model do
  describe "valid factory" do
    let(:medicine) { create(:medicine) }
    let(:ingredient) { create(:ingredient) }

    it { is_expected.to have_a_valid_factory.with_associations({medicine:, ingredient:}) }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:medicine_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:ingredient_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:strength).of_type(:decimal).with_options(precision: 8, scale: 2) }
    it { is_expected.to have_db_column(:uom).of_type(:enum) }
    it { is_expected.to have_db_column(:active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:medicine_id) }
    it { is_expected.to have_db_index(:ingredient_id) }

    it { is_expected.to have_foreign_key(:ingredient_id).with_name(:fk_medicine_ingredients_ingredient_id_on_ingredients).on_delete(:restrict) }
    it { is_expected.to have_foreign_key(:medicine_id).with_name(:fk_medicine_ingredients_medicine_id_on_medicines).on_delete(:cascade) }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      medicine_ingredient = build(:medicine_ingredient)
      expect(medicine_ingredient.active).to be_falsy
    end
  end

  describe "validations" do
    describe "#medicine_id" do
      it { is_expected.to validate_presence_of(:medicine_id).with_message("is required") }
    end

    describe "#ingredient_id" do
      it { is_expected.to validate_presence_of(:ingredient_id).with_message("is required") }
    end

    describe "#strength" do
      it { is_expected.to validate_presence_of(:strength).with_message("is required") }
      ## TODO: Add spec for greater than or equal to
      it { is_expected.to validate_numericality_of(:strength) }
    end

    describe "#uom" do
      it { is_expected.to validate_presence_of(:uom).with_message("is required") }
      it { is_expected.to validate_inclusion_of(:uom).in_array(described_class.unit_of_measurements.keys) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:medicine).inverse_of(:medicine_ingredients).touch(true) }
    it { is_expected.to belong_to(:ingredient).inverse_of(:medicine_ingredients) }
  end

  describe "delegates" do
    it { is_expected.to delegate_method(:name).to(:ingredient).with_prefix }
    it { is_expected.to delegate_method(:name).to(:medicine).with_prefix }
  end
end
