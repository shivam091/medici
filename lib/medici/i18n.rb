# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module I18n
    extend self

    def day_name(day)
      ::I18n.t("day_names", scope: "date")[day % 7]
    end

    def day_letter(day)
      ::I18n.t("abbr_day_names", scope: "date")[day % 7].first
    end

    def month_name(month)
      ::I18n.t("month_names", scope: "date")[month]
    end
  end
end
