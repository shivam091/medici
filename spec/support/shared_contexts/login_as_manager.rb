# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_context "login as manager" do
  let(:manager) { create(:manager, :active, :confirmed, :with_store) }

  before do
    sign_in(manager)
  end

  after do
    sign_out(manager)
  end
end
