# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Countries::DestroyService, type: :service do
  describe "#call" do
    let(:country) { create(:country) }
    subject { described_class.(country) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Country '#{country.name}' was successfully destroyed.")
        expect(subject.payload[:country]).to eq(country)
        expect(::Country.find_by(id: country.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(country).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Country '#{country.name}' could not be destroyed.")
        expect(subject.payload[:country]).to eq(country)
      end

      include_examples "does not change count of objects", ::Country
    end
  end
end
