# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "io/console"

# Prompt the user to input something
#
# message - the message to display before input
# choices - array of strings of acceptable answers or nil for any answer
#
# Returns the user's answer
def prompt(message, choices = nil)
  begin
    print(message)
    answer = STDIN.gets.chomp
  end while choices.present? && !choices.include?(answer)
  answer
end
