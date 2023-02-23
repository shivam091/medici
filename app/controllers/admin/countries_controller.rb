# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CountriesController < Admin::BaseController

  # GET /admin/countries
  def index
    @countries = ::Country.active.includes(:currency)
    @pagy, @countries = pagy(@countries)
  end
end
