# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/create_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::CreateService, type: :service do
  let(:manufacturer_attributes) { attributes_for(:manufacturer) }
  subject { described_class.(manufacturer_attributes) }

  describe "#call" do
    context "when manufacturer is valid" do
      it "returns a success response with the manufacturer" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Manufacturer '#{subject.payload[:manufacturer].name}' was successfully created.")
        expect(subject.payload).to include(manufacturer: instance_of(::Manufacturer))
      end

      include_examples "creates a new object", ::Manufacturer
    end

    context "when manufacturer is invalid" do
      let(:manufacturer_attributes) { attributes_for(:manufacturer, name: "") }

      it "returns an error response with the manufacturer" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Manufacturer could not be created.")
        expect(subject.payload).to include(manufacturer: instance_of(::Manufacturer))
      end

      include_examples "does not change count of objects", ::Manufacturer
    end
  end
end
