# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/create_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::CreateService, type: :service do
  let(:dosage_form_attributes) { attributes_for(:dosage_form) }
  subject { described_class.(dosage_form_attributes) }

  describe "#call" do
    context "when dosage form is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("Dosage form 'Spray' was successfully created.")
      end

      include_examples "creates a new object", ::DosageForm

      include_examples "returns a success response"
    end

    context "when dosage form is invalid" do
      let(:dosage_form_attributes) { attributes_for(:dosage_form, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Dosage form could not be created.")
      end

      include_examples "does not change count of objects", ::DosageForm

      include_examples "returns an error response"
    end
  end
end
