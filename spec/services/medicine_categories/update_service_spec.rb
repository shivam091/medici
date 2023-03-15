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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
        expect(medicine_category.reload.name).to eq(medicine_category.name)
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(medicine_category).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine category could not be updated.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end
    end
  end
end
