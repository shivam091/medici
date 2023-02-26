# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ManufacturersController < ApplicationController
  def self.local_prefixes
    [controller_path, controller_path.sub(/^(admin|cashier|manager)\//, "")]
  end

  private_class_method :local_prefixes
end
