# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Countries::UpdateService < ApplicationService
  def initialize(country, country_attributes)
    @country = country
    @country_attributes = country_attributes.dup
  end

  def call
    update_country
  end

  private

  attr_reader :country, :country_attributes

  def update_country
    if country.update(country_attributes)
      ::ServiceResponse.success(
        message: t("countries.update.success", country_name: country.name),
        payload: {country: country}
      )
    else
      ::ServiceResponse.error(
        message: t("countries.update.error"),
        payload: {country: country}
      )
    end
  end
end
