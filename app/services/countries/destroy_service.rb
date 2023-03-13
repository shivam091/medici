# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Countries::DestroyService < ApplicationService
  def initialize(country)
    @country = country
  end

  def call
    destroy_country
  end

  private

  attr_reader :country

  def destroy_country
    if country.destroy
      ::ServiceResponse.success(
        message: t("countries.destroy.success", country_name: country.name),
        payload: {country: country}
      )
    else
      ::ServiceResponse.error(
        message: t("countries.destroy.error", country_name: country.name),
        payload: {country: country}
      )
    end
  end
end
