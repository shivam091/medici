# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec.shared_context "login as super admin" do
  let(:super_admin) { create(:super_admin, :active, :confirmed, :with_store) }

  before do
    sign_in(super_admin)
  end

  after do
    sign_out(super_admin)
  end
end
