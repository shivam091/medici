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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:medicine]).to eq(medicine)
        expect(medicine.reload.name).to eq(medicine.name)
        expect(subject.message).to eq("Medicine '#{subject.payload[:medicine].reference_code} (#{medicine.name})' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(medicine).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine could not be updated.")
        expect(subject.payload[:medicine]).to eq(medicine)
      end
    end
  end
end
