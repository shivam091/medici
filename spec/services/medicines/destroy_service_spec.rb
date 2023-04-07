# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::DestroyService, type: :service do
  describe "#call" do
    let!(:medicine) { create(:medicine, :with_user) }
    subject { described_class.(medicine) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Medicine

      it "sets flash message" do
        expect(subject.message).to eq("Medicine 'MED-FL000000001 (Fluticasone Furoate Aqueous Nasal Spray)' was successfully destroyed.")
        expect(::Medicine.find_by(id: medicine.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(medicine).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Medicine

      it "sets flash message" do
        expect(subject.message).to eq("Medicine 'MED-FL000000001 (Fluticasone Furoate Aqueous Nasal Spray)' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
