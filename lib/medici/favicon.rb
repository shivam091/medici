# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Favicon
    extend self

    def main
      image_name = "favicon.ico"
      ActionController::Base.helpers.image_path(image_name, host: host)
    end

    private

    def host
      ActionController::Base.asset_host
    end
  end
end
