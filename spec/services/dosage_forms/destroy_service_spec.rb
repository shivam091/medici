# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/destroy_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::DestroyService, type: :service do
  describe "#call" do
    let!(:dosage_form) { create(:dosage_form) }
    subject { described_class.(dosage_form) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::DosageForm

      it "sets flash mmesage" do
        expect(subject.message).to eq("Dosage form 'Spray' was successfully destroyed.")
        expect(::DosageForm.find_by(id: dosage_form.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(dosage_form).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::DosageForm

      it "sets flash mmesage" do
        expect(subject.message).to eq("Dosage form 'Spray' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
