# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ExpensesController < ApplicationController
  def self.local_prefixes
    [controller_path]
  end

  private_class_method :local_prefixes
end
