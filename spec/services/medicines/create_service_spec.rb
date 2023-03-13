# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/create_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::CreateService, type: :service do
  let(:medicine_attributes) { attributes_for(:medicine) }
  subject { described_class.(medicine_attributes) }

  describe "#call" do
    context "when medicine is valid" do
      it "returns a success response with the medicine" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Medicine '#{subject.payload[:medicine].reference_code} (#{subject.payload[:medicine].name})' was successfully created.")
        expect(subject.payload).to include(medicine: instance_of(::Medicine))
      end

      include_examples "creates a new object", ::Medicine
    end

    context "when medicine is invalid" do
      let(:medicine_attributes) { attributes_for(:medicine, name: "") }

      it "returns an error response with the medicine" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Medicine could not be created.")
        expect(subject.payload).to include(medicine: instance_of(::Medicine))
      end

      include_examples "does not change count of objects", ::Medicine
    end
  end
end
