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
      include_examples "deletes an object", ::MedicineCategory

      it "sets flash message" do
        expect(subject.message).to eq("Medicine category 'Antihistamines' was successfully destroyed.")
        expect(::MedicineCategory.find_by(id: medicine_category.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(medicine_category).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::MedicineCategory

      it "sets flash message" do
        expect(subject.message).to eq("Medicine category 'Antihistamines' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
