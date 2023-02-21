# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationService
  class << self
    def call(*args, &block)
      new(*args, &block).call
    end
  end
end
