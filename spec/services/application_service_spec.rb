# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/application_service_spec.rb

require "spec_helper"

RSpec.describe ApplicationService, type: :service do
  describe ".call" do
    let(:dummy_service_class) do
      Class.new(ApplicationService) do
        def call
          :service_result
        end
      end
    end

    let(:service_instance) { instance_double("DummyService") }

    it "instantiates a new instance of the service class and calls #call on it" do
      expect(dummy_service_class).to receive(:new).and_return(service_instance)
      expect(service_instance).to receive(:call).and_return(:service_result)

      result = dummy_service_class.call
      expect(result).to eq(:service_result)
    end
  end
end
