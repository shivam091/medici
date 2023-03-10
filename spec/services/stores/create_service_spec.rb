# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/create_service_spec.rb

require "spec_helper"

RSpec.describe Stores::CreateService, type: :service do
  let(:store_attributes) { attributes_for(:store) }
  subject { described_class.(store_attributes) }

  describe "#call" do
    context "when store is valid" do
      it "returns a success response with the store" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Store '#{subject.payload[:store].name}' was successfully created.")
        expect(subject.payload).to include(store: instance_of(::Store))
      end

      include_examples "creates a new object", ::Store
    end

    context "when store is invalid" do
      let(:store_attributes) { attributes_for(:store, name: "") }

      it "returns an error response with the store" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Store could not be created.")
        expect(subject.payload).to include(store: instance_of(::Store))
      end

      include_examples "does not change count of objects", ::Store
    end
  end
end
