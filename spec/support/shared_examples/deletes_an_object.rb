# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "deletes an object" do |klass|
  it "deletes the #{klass.model_name.human.downcase}" do
    expect { subject }.to change(klass, :count).by(-1)
  end
end
