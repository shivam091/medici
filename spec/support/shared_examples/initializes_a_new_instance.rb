# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "initializes a new instance" do |object_name, klass|
  it "initializes a new instance" do
    expect(ivar(object_name)).to be_a_new(klass)
  end
end
