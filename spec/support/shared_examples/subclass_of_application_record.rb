# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_examples "subclass of ApplicationRecord" do
  describe "ancestors" do
    it { expect(described_class.ancestors).to include ApplicationRecord }
  end
end
