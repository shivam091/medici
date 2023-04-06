# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::DestroyService, type: :service do
  describe "#call" do
    let(:manufacturer) { create(:manufacturer) }
    subject { described_class.(manufacturer) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' was successfully destroyed.")
        expect(subject.payload[:manufacturer]).to eq(manufacturer)
        expect(::Manufacturer.find_by(id: manufacturer.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(manufacturer).to receive(:destroy).and_return(false) }
      
      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' could not be destroyed.")
        expect(subject.payload[:manufacturer]).to eq(manufacturer)
      end

      include_examples "does not change count of objects", ::Manufacturer
    end
  end
end
