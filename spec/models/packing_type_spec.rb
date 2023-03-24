# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/packing_type_spec.rb

require "spec_helper"

RSpec.describe PackingType, type: :model do

  subject(:packing_type) { build(:packing_type) }

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
    it { is_expected.to have_db_column(:is_active).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:timestamptz).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:timestamptz).with_options(null: false) }

    it { is_expected.to have_db_index(:name).unique(true) }

    it { is_expected.to have_check_constraint("chk_9ef2625dfe").with_condition("char_length(name::text) <= 55") }
    it { is_expected.to have_check_constraint("chk_c41aed63fb").with_condition("name IS NOT NULL AND name::text <> ''::text") }
  end

  describe "default values" do
    it "should set false as default value for #is_active" do
      expect(packing_type.is_active).to be_falsy
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:medicines).dependent(:restrict_with_exception) }
  end

  include_examples "apply default scope on name asc"

  describe "validations" do
    describe "#name" do
      it { is_expected.to validate_presence_of(:name).with_message("is required") }
      it { is_expected.to validate_length_of(:name).is_at_most(55).with_message("is too long (maximum is 55 characters)") }
      it { is_expected.to validate_uniqueness_of(:name).with_message("is already in use") }
    end
  end

  describe "class methods" do
    describe ".select_options" do
      it "should return array of packing types for select list" do
        packing_type = create(:packing_type, :active)
        expect(described_class.select_options).to eq([[packing_type.name, packing_type.id]])
      end
    end
  end
end
