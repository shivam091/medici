# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::DestroyService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    subject { described_class.(ingredient) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully destroyed.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
        expect(::Ingredient.find_by(id: ingredient.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(ingredient).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be destroyed.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end

      include_examples "does not change count of objects", ::Ingredient
    end
  end
end
