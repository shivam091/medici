# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Stores::DestroyService, type: :service do
  describe "#call" do
    let!(:store) { create(:store) }
    subject { described_class.(store) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Store

      it "sets flash message" do
        expect(subject.message).to eq("Store 'Store' was successfully destroyed.")
        expect(::Store.find_by(id: store.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(store).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Store

      it "sets flash message" do
        expect(subject.message).to eq("Store 'Store' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
