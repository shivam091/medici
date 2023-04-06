# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/activate_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::ActivateService, type: :service do
  describe "#call" do
    let(:currency) { create(:currency) }
    subject { described_class.(currency) }

    context "when activation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Currency '#{currency.name}' was successfully activated.")
        expect(subject.payload[:currency]).to eq(currency)
      end
    end

    context "when activation fails" do
      it "returns an error response" do
        allow(currency).to receive(:activate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Currency '#{currency.name}' could not be activated.")
        expect(subject.payload[:currency]).to eq(currency)
      end
    end
  end
end
