# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_context "login as cashier" do
  let(:cashier) { create(:cashier, :active, :confirmed) }

  before do
    sign_in(cashier)
  end

  after do
    sign_out(cashier)
  end
end
