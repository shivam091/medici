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
      it "sets flash message" do
        expect(subject.message).to eq("Store 'Store' was successfully created.")
      end

      include_examples "creates a new object", ::Store

      include_examples "returns a success response"
    end

    context "when store is invalid" do
      let(:store_attributes) { attributes_for(:store, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Store could not be created.")
      end

      include_examples "does not change count of objects", ::Store

      include_examples "returns an error response"
    end
  end
end
