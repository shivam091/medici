# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ViewAssigns
  def ivar(key = nil)
    ivars = {}.with_indifferent_access
    @controller.view_assigns.each { |k, v| ivars.regular_writer(k, v) }
    key.nil? ? ivars : ivars[key]
  end
end
