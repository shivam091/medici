# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::DestroyService, type: :service do
  describe "#call" do
    let(:supplier) { create(:supplier) }
    subject { described_class.(supplier) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Supplier '#{supplier.name}' was successfully destroyed.")
        expect(subject.payload[:supplier]).to eq(supplier)
        expect(::Supplier.find_by(id: supplier.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(supplier).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Supplier '#{supplier.name}' could not be destroyed.")
        expect(subject.payload[:supplier]).to eq(supplier)
      end

      include_examples "does not change count of objects", ::Supplier
    end
  end
end
