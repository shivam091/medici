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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:store]).to eq(store)
        expect(store.reload.name).to eq(store.name)
        expect(subject.message).to eq("Store '#{store.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(store).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Store could not be updated.")
        expect(subject.payload[:store]).to eq(store)
      end
    end
  end
end
