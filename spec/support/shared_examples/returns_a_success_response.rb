# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "returns a success response" do |klass|
  it "returns a success response" do
    expect(subject).to be_a(ServiceResponse)
    expect(subject).to be_success
  end
end
