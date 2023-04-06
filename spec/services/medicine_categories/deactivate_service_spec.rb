# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::DeactivateService, type: :service do
  describe "#call" do
    let(:medicine_category) { create(:medicine_category) }
    subject { described_class.(medicine_category) }

    context "when deactivation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully deactivated.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end
    end

    context "when deactivation fails" do
      it "returns an error response" do
        allow(medicine_category).to receive(:deactivate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' could not be deactivated.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end
    end
  end
end
