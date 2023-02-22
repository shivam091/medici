# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RequestLogs::CreateService < ApplicationService
  def initialize(user, request)
    @user = user
    @request = request
  end

  def call
    persist_request_log
  end

  private

  attr_reader :user, :request

  def persist_request_log
    request_log = ::RequestLog.new
    if user.present?
      request_log.assign_attributes(user: user)
    end
    request_log.assign_attributes(
      uuid: request.uuid,
      uri: request.url,
      method: (request.params["_method"] || request.method),
      remote_address: IPAddr.new(request.remote_ip),
      session_id: (request.session.id || ""),
      session_private_id: (request.session.id&.private_id || ""),
      is_xhr: request.xhr?,
      ip_info: request.env["ipinfo"],
    )
    request_log.save
  end
end
