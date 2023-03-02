# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "assigns a new object" do |object_name, klass|
  it "assigns a new #{klass} to @#{object_name}" do
    expect(ivar(object_name)).to be_a_new(klass)
  end
end
