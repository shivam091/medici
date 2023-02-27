# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MedicinesShared
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do

      # GET /(admin|manager)/medicines
      def index
        @medicines = ::Medicine.active
        @pagy, @medicines = pagy(@medicines)
      end
    end
  end
end
