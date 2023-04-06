# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::DeactivateService, type: :service do
  describe "#call" do
    let(:medicine_category) { create(:medicine_category, :active) }
    subject { described_class.(medicine_category) }

    context "when deactivation is successful" do
      it "deactivates the medicine category" do
        expect { subject }.to change { medicine_category.reload.is_active? }.to(false)
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(medicine_category).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the medicine category" do
        expect { subject }.not_to change { medicine_category.reload.is_active? }
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
