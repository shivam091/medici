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
      it "sets flash message" do
        expect(subject.message).to eq("Manufacturer 'Manufacturer' was successfully created.")
      end

      include_examples "creates a new object", ::Manufacturer

      include_examples "returns a success response"
    end

    context "when manufacturer is invalid" do
      let(:manufacturer_attributes) { attributes_for(:manufacturer, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Manufacturer could not be created.")
      end

      include_examples "does not change count of objects", ::Manufacturer

      include_examples "returns an error response"
    end
  end
end
