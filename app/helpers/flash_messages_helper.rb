# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# Helper methods for creating flash messages within the application.
#
module FlashMessagesHelper
  FLASH_TYPES = %i(warning info notice alert).freeze unless const_defined?(:FLASH_TYPES)

  def flash_messages(options = {})
    flash_messages = []
    flash.each do |msg_type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      msg_type = msg_type.to_sym

      next unless FLASH_TYPES.include?(msg_type)

      Array(message).each do |msg|
        text = tag.div(class: "alert alert-#{color_for(msg_type)} d-flex align-items-center alert-dismissible fade show") do
          concat(external_svg_tag("svgs/#{icon_for(msg_type)}.svg", width: "24px", height: "24px", fill: "currentColor", class: "flex-shrink-0 me-2"))
          concat(tag.div(msg))
          concat(tag.button("", class: "btn-close", "data-bs-dismiss" => "alert", "aria-label" => "Close"))
        end.html_safe
        # text = content_tag(:div,
        #   content_tag(:button, "", class: "btn-close", "data-bs-dismiss" => "alert", "aria-label" => "Close") +
        #     "<div class='alert-icon alert-icon-#{color_for(msg_type)}'> #{external_svg_tag("svgs/#{icon_for(msg_type)}.svg", width: "35px", height: "35px", fill: "currentColor")} </div>".html_safe +
        #     "<div class='alert-message'>#{msg}</div>".html_safe,
        #     class: "alert alert-#{color_for(msg_type)} alert-dismissible fade show")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  private

  def color_for(msg_type)
    {
      notice: :success,
      alert: :danger,
      warning: :warning,
      info: :info
    }.with_indifferent_access[msg_type]
  end

  def icon_for(msg_type)
    {
      notice: "check-circle",
      alert: "error-circle",
      warning: "exclamation-triangle",
      info: "info-circle"
    }.with_indifferent_access[msg_type]
  end
end
