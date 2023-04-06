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
      it "sets flash message" do
        expect(subject.message).to eq("Packing type 'Bottles' was successfully created.")
      end

      include_examples "creates a new object", ::PackingType

      include_examples "returns a success response"
    end

    context "when packing type is invalid" do
      let(:packing_type_attributes) { attributes_for(:packing_type, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Packing type could not be created.")
      end

      include_examples "does not change count of objects", ::PackingType

      include_examples "returns an error response"
    end
  end
end
