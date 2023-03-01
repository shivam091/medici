# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::UsersController < Admin::BaseController

  # GET /admin/users
  def index
    @users = ::User.active.includes(:role, :store)
    @pagy, @users = pagy(@users)
  end
end
