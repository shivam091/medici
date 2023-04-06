# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/create_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::CreateService, type: :service do
  let(:manager) { create(:manager, :confirmed, :active, :with_store) }
  let(:medicine_attributes) { attributes_for(:medicine) }
  subject { described_class.(manager, medicine_attributes) }

  describe "#call" do
    context "when medicine is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("Medicine 'MED-FL000000001 (Fluticasone Furoate Aqueous Nasal Spray)' was successfully created.")
      end

      include_examples "creates a new object", ::Medicine

      include_examples "returns a success response"
    end

    context "when medicine is invalid" do
      let(:medicine_attributes) { attributes_for(:medicine, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Medicine could not be created.")
      end

      include_examples "does not change count of objects", ::Medicine

      include_examples "returns an error response"
    end
  end
end
