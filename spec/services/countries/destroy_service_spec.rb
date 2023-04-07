# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Countries::DestroyService, type: :service do
  describe "#call" do
    let!(:country) { create(:country) }
    subject { described_class.(country) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Country

      it "sets flash message" do
        expect(subject.message).to eq("Country 'India' was successfully destroyed.")
        expect(::Country.find_by(id: country.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(country).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Country

      it "sets flash message" do
        expect(subject.message).to eq("Country 'India' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
