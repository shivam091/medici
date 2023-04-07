# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::DestroyService, type: :service do
  describe "#call" do
    let!(:supplier) { create(:supplier) }
    subject { described_class.(supplier) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Supplier

      it "sets flash message" do
        expect(subject.message).to eq("Supplier 'Supplier' was successfully destroyed.")
        expect(::Supplier.find_by(id: supplier.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(supplier).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Supplier

      it "sets flash message" do
        expect(subject.message).to eq("Supplier 'Supplier' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
