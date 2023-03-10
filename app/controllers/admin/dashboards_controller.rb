# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::DashboardsController < Admin::BaseController

  # GET /admin/dashboard
  def show
    @top_selling_medicines = []
  end
end
