# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/create_service_spec.rb

require "spec_helper"

RSpec.describe Countries::CreateService, type: :service do
  let(:country_attributes) { attributes_for(:country) }
  subject { described_class.(country_attributes) }

  describe "#call" do
    context "when country is valid" do
      it "returns a success response with the country" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Country '#{subject.payload[:country].name}' was successfully created.")
        expect(subject.payload).to include(country: instance_of(::Country))
      end

      include_examples "creates a new object", ::Country
    end

    context "when country is invalid" do
      let(:country_attributes) { attributes_for(:country, name: "") }

      it "returns an error response with the country" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Country could not be created.")
        expect(subject.payload).to include(country: instance_of(::Country))
      end

      include_examples "does not change count of objects", ::Country
    end
  end
end
