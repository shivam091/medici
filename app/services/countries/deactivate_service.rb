# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Countries::DeactivateService < ApplicationService
  def initialize(country)
    @country = country
  end

  def call
    deactivate_country
  end

  private

  attr_reader :country

  def deactivate_country
    if country.deactivate!
      ::ServiceResponse.success(
        message: t("countries.deactivate.success", country_name: country.name),
        payload: {country: country}
      )
    else
      ::ServiceResponse.error(
        message: t("countries.deactivate.error", country_name: country.name),
        payload: {country: country}
      )
    end
  end
end
