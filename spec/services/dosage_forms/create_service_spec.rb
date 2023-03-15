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
      it "returns a success response with the dosage form" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Dosage form '#{subject.payload[:dosage_form].name}' was successfully created.")
        expect(subject.payload).to include(dosage_form: instance_of(::DosageForm))
      end

      include_examples "creates a new object", ::DosageForm
    end

    context "when dosage form is invalid" do
      let(:dosage_form_attributes) { attributes_for(:dosage_form, name: "") }

      it "returns an error response with the dosage form" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form could not be created.")
        expect(subject.payload).to include(dosage_form: instance_of(::DosageForm))
      end

      include_examples "does not change count of objects", ::DosageForm
    end
  end
end
