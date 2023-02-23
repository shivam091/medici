# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# Helper module containing methods for rendering modals.
#
module ModalsHelper
  def render_modal(title: "", size: :md, position: "", &block)
    position_class = modal_position_class(position)
    dialog_class = modal_dialog_class(size)
    render "shared/remote_modal", title: title, dialog_class: dialog_class, position_class: position_class, &block
  end

  private

  def modal_dialog_class(size)
    case size
    when :sm
      "modal-sm"
    when :lg
      "modal-lg"
    when :xl
      "modal-xl"
    when :fullscreen
      "modal-fullscreen"
    else
      "modal-md"
    end
  end

  def modal_position_class(position)
    case position
    when :left
      "modal-left"
    when :right
      "modal-right"
    when :top
      "modal-top"
    when :bottom
      "modal-bottom"
    else
      ""
    end
  end
end
