# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/create_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::CreateService, type: :service do
  let(:packing_type_attributes) { attributes_for(:packing_type) }
  subject { described_class.(packing_type_attributes) }

  describe "#call" do
    context "when packing type is valid" do
      it "returns a success response with the packing type" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Packing type '#{subject.payload[:packing_type].name}' was successfully created.")
        expect(subject.payload).to include(packing_type: instance_of(::PackingType))
      end

      include_examples "creates a new object", ::PackingType
    end

    context "when packing type is invalid" do
      let(:packing_type_attributes) { attributes_for(:packing_type, name: "") }

      it "returns an error response with the packing type" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Packing type could not be created.")
        expect(subject.payload).to include(packing_type: instance_of(::PackingType))
      end

      include_examples "does not change count of objects", ::PackingType
    end
  end
end
