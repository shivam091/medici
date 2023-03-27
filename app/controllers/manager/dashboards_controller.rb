# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Manager::DashboardsController < Manager::BaseController

  # GET /manager/dashboard
  def show
    @stores = ::Store.includes(:currency)
  end
end
