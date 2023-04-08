# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/update_service_spec.rb

require "spec_helper"

RSpec.describe Stores::UpdateService, type: :service do
  describe "#call" do
    let(:store) { create(:store) }
    let(:store_attributes) { attributes_for(:store, name: "New name") }
    subject { described_class.(store, store_attributes) }

    context "when update is successful" do
      it "updates the store" do
        expect(subject.payload[:store].name).to eq("New name")
        expect(subject.message).to eq("Store 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(store).to receive(:update).and_return(false) }

      it "does not update the store" do
        expect(subject.payload[:store].name).to eq("Store")
        expect(subject.message).to eq("Store could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
