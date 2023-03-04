# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_context "login as admin" do
  let(:admin) { create(:admin, :active, :confirmed) }

  before do
    sign_in(admin)
  end

  after do
    sign_out(admin)
  end
end
