# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/ingredient_spec.rb

require "spec_helper"

RSpec.describe Ingredient, type: :model do
  describe "valid factory" do
    it { is_expected.to have_a_valid_factory }
  end

  describe "superclasses" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end

  describe "included modules" do
    it { is_expected.to include_module(Sortable) }
    it { is_expected.to include_module(Filterable) }
  end

  describe "attributes, indexes, and foreign keys" do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:name).unique(true) }

    it { is_expected.to have_check_constraint("chk_62cbc59142").with_condition("char_length(name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_44ab271035").with_condition("name IS NOT NULL AND name::text <> ''::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      ingredient = build(:ingredient)
      expect(ingredient.is_active).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:medicine_ingredients).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:medicines).through(:medicine_ingredients).source(:medicine).inverse_of(:medicine_ingredients) }
  end

  include_examples "apply default scope on name"

  describe "validations" do
    describe "#name" do
      subject { build(:ingredient) }

      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_least(0) }
      it { is_expected.to validate_length_of(:name).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:name).with_message("is already in use") }
    end
  end

  describe ".select_options" do
    it "should return array of ingredients for select list" do
      ingredient = create(:ingredient, :active)
      expect(described_class.select_options).to eq([[ingredient.name, ingredient.id]])
    end
  end
end
