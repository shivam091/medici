# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

date_time_formats = {
  month_and_year: "%B, %Y",
  short_ordinal: -> (time) { time.strftime("%B #{time.day.ordinalize}") }
}

Time::DATE_FORMATS.merge!(date_time_formats)
Date::DATE_FORMATS.merge!(date_time_formats)
