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
      it "sets flash message" do
        expect(subject.message).to eq("Country 'India' was successfully created.")
      end

      include_examples "creates a new object", ::Country

      include_examples "returns a success response"
    end

    context "when country is invalid" do
      let(:country_attributes) { attributes_for(:country, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Country could not be created.")
      end

      include_examples "does not change count of objects", ::Country

      include_examples "returns an error response"
    end
  end
end
