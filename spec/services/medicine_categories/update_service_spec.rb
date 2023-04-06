# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/update_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::UpdateService, type: :service do
  describe "#call" do
    let(:medicine_category) { create(:medicine_category) }
    let(:medicine_category_attributes) { attributes_for(:medicine_category, name: "New name") }
    subject { described_class.(medicine_category, medicine_category_attributes) }

    context "when update is successful" do
      it "updates the medicine category" do
        expect(subject.payload[:medicine_category].name).to eq("New name")
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(medicine_category).to receive(:update).and_return(false) }

      it "does not update the medicine category" do
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
        expect(subject.message).to eq("Medicine category could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
