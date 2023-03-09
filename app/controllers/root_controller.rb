# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RootController < ApplicationController
  def index
    redirect_to root_path
  end
end
