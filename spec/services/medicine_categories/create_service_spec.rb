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
      it "returns a success response with the medicine_category" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine category '#{subject.payload[:medicine_category].name}' was successfully created.")
        expect(subject.payload).to include(medicine_category: instance_of(::MedicineCategory))
      end

      include_examples "creates a new object", ::MedicineCategory
    end

    context "when medicine_category is invalid" do
      let(:medicine_category_attributes) { attributes_for(:medicine_category, name: "") }

      it "returns an error response with the medicine_category" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine category could not be created.")
        expect(subject.payload).to include(medicine_category: instance_of(::MedicineCategory))
      end

      include_examples "does not change count of objects", ::MedicineCategory
    end
  end
end
