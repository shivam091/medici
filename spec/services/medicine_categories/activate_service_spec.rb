# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicine_categories/activate_service_spec.rb

require "spec_helper"

RSpec.describe MedicineCategories::ActivateService, type: :service do
  describe "#call" do
    let(:medicine_category) { create(:medicine_category) }
    subject { described_class.(medicine_category) }

    context "when activation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' was successfully activated.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end
    end

    context "when activation fails" do
      it "returns an error response" do
        allow(medicine_category).to receive(:activate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Medicine category '#{medicine_category.name}' could not be activated.")
        expect(subject.payload[:medicine_category]).to eq(medicine_category)
      end
    end
  end
end
