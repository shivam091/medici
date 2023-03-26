# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::DiscountsController < Admin::BaseController
  before_action do
    if action_name.in?(["index", "new", "create"])
      authorize ::Discount
    else
      authorize @discount
    end
  end

  # GET /admin/discounts
  def index
    @discounts = policy_scope(::Discount).includes(:country)
    @pagy, @discounts = pagy(@discounts)
  end
end
