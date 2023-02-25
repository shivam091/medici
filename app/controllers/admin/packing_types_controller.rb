# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::PackingTypesController < Admin::BaseController

  # GET /admin/packing-types
  def index
    @packing_types = ::PackingType.active
    @pagy, @packing_types = pagy(@packing_types)
  end
end
