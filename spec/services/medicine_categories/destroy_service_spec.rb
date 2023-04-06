# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/destroy_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::DestroyService, type: :service do
  describe "#call" do
    let!(:medicine_category) { create(:medicine_category) }
    subject { described_class.(medicine_category) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully destroyed.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
        expect(::MedicineCategory.find_by(id: medicine_category.id)).to be_nil
      end

      include_examples "deletes an object", ::MedicineCategory
    end

    context "when destroy fails" do
      before { allow(medicine_category).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' could not be destroyed.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end

      include_examples "does not change count of objects", ::MedicineCategory
    end
  end
end
