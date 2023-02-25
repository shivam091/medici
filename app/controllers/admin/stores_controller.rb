# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::StoresController < Admin::BaseController

  # GET /admin/stores
  def index
    @stores = ::Store.active.includes(:address)
    @pagy, @stores = pagy(@stores)
  end
end
