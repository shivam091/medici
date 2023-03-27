# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PurchaseOrdersShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do
    end
  end
end
