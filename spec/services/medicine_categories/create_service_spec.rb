# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/create_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::CreateService, type: :service do
  let(:medicine_category_attributes) { attributes_for(:medicine_category) }
  subject { described_class.(medicine_category_attributes) }

  describe "#call" do
    context "when medicine_category is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("Medicine category 'Antihistamines' was successfully created.")
      end

      include_examples "creates a new object", ::MedicineCategory

      include_examples "returns a success response"
    end

    context "when medicine_category is invalid" do
      let(:medicine_category_attributes) { attributes_for(:medicine_category, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Medicine category could not be created.")
      end

      include_examples "does not change count of objects", ::MedicineCategory

      include_examples "returns an error response"
    end
  end
end
