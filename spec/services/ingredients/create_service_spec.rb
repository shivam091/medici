# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/create_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::CreateService, type: :service do
  let(:ingredient_attributes) { attributes_for(:ingredient) }
  subject { described_class.(ingredient_attributes) }

  describe "#call" do
    context "when ingredient is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("Ingredient 'Fluticasone furoate' was successfully created.")
      end

      include_examples "creates a new object", ::Ingredient

      include_examples "returns a success response"
    end

    context "when ingredient is invalid" do
      let(:ingredient_attributes) { attributes_for(:ingredient, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Ingredient could not be created.")
      end

      include_examples "does not change count of objects", ::Ingredient

      include_examples "returns an error response"
    end
  end
end
