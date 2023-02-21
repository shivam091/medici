# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# <%= test_unit_path %>

require "test_helper"

class <%= class_name %>ServiceTest < ActiveSupport::TestCase
  def test_some_stuff
    assert (1 == 2), "You best test yourself before you wreck yourself!"
  end
end
