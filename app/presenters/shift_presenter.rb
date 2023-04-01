# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ShiftPresenter < BasePresenter
  presents :shift

  def starts_at
    @model.starts_at.strftime("%H:%M")
  end

  def ends_at
    @model.ends_at.strftime("%H:%M")
  end
end
