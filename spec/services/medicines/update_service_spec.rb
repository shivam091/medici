# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/update_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::UpdateService, type: :service do
  describe "#call" do
    let(:medicine) { create(:medicine, :with_user) }
    let(:medicine_attributes) { attributes_for(:medicine, name: "New name") }
    subject { described_class.(medicine, medicine_attributes) }

    context "when update is successful" do
      it "updates the medicine" do
        expect(subject.payload[:medicine].name).to eq(medicine.name)
        expect(subject.message).to eq("Medicine 'MED-FL000000001 (New name)' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(medicine).to receive(:update).and_return(false) }

      it "does not update the medicine" do
        expect(subject.payload[:medicine]).to eq(medicine)
        expect(subject.message).to eq("Medicine could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
