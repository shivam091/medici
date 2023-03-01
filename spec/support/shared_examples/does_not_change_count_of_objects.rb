# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "does not change count of objects" do |klass|
  it "does not change count of #{klass.model_name.human.downcase.pluralize}" do
    expect { subject }.not_to change { klass.count }
  end
end
