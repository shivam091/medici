# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/update_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::UpdateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    let(:ingredient_attributes) { attributes_for(:ingredient, name: "New name") }
    subject { described_class.(ingredient, ingredient_attributes) }

    context "when update is successful" do
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:ingredient]).to eq(ingredient)
        expect(ingredient.reload.name).to eq(ingredient.name)
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      it "returns an error response" do
        allow(ingredient).to receive(:update).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient could not be updated.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end
    end
  end
end
