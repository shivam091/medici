# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Countries::ActivateService < ApplicationService
  def initialize(country)
    @country = country
  end

  def call
    activate_country
  end

  private

  attr_reader :country

  def activate_country
    if country.activate!
      ::ServiceResponse.success(
        message: t("countries.activate.success", country_name: country.name),
        payload: {country: country}
      )
    else
      ::ServiceResponse.error(
        message: t("countries.activate.error", country_name: country.name),
        payload: {country: country}
      )
    end
  end
end
