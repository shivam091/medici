# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::DestroyService, type: :service do
  describe "#call" do
    let!(:manufacturer) { create(:manufacturer) }
    subject { described_class.(manufacturer) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Manufacturer

      it "sets flash message" do
        expect(subject.message).to eq("Manufacturer 'Manufacturer' was successfully destroyed.")
        expect(::Manufacturer.find_by(id: manufacturer.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(manufacturer).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Manufacturer

      it "sets flash message" do
        expect(subject.message).to eq("Manufacturer 'Manufacturer' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
