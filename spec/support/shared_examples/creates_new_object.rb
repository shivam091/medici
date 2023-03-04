# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "creates a new object" do |klass|
  it "creates a new #{klass.model_name.human.downcase}" do
    expect { subject }.to change(klass, :count).by(1)
  end
end
