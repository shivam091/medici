# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/destroy_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::DestroyService, type: :service do
  describe "#call" do
    let(:dosage_form) { create(:dosage_form) }
    subject { described_class.(dosage_form) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully destroyed.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
        expect(::DosageForm.find_by(id: dosage_form.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(dosage_form).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be destroyed.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end

      include_examples "does not change count of objects", ::DosageForm
    end
  end
end
