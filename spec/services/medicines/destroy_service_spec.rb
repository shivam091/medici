# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::DestroyService, type: :service do
  describe "#call" do
    let(:medicine) { create(:medicine) }
    subject { described_class.(medicine) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine '#{subject.payload[:medicine].reference_code} (#{medicine.name})' was successfully destroyed.")
        expect(subject.payload[:medicine]).to eq(medicine)
        expect(::Medicine.find_by(id: medicine.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before do
        allow(medicine).to receive(:destroy).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine '#{subject.payload[:medicine].reference_code} (#{medicine.name})' could not be destroyed.")
        expect(subject.payload[:medicine]).to eq(medicine)
      end

      include_examples "does not change count of objects", ::Medicine
    end
  end
end
