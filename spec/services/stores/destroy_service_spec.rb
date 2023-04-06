# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Stores::DestroyService, type: :service do
  describe "#call" do
    let(:store) { create(:store) }
    subject { described_class.(store) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Store '#{store.name}' was successfully destroyed.")
        expect(subject.payload[:store]).to eq(store)
        expect(::Store.find_by(id: store.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(store).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Store '#{store.name}' could not be destroyed.")
        expect(subject.payload[:store]).to eq(store)
      end

      include_examples "does not change count of objects", ::Store
    end
  end
end
