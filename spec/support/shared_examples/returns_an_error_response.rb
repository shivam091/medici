# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "returns an error response" do |klass|
  it "returns an error response" do
    expect(subject).to be_a(ServiceResponse)
    expect(subject).to be_error
  end
end
