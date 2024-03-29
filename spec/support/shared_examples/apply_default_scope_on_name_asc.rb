# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "apply default scope on name asc" do
  describe "default scope" do
    it "should apply default scope on #name" do
      expect(described_class.all.to_sql).to eq(described_class.order(described_class[:name].lower.asc).to_sql)
    end
  end
end
