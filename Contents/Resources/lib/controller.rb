require_relative '../bundle/bundler/setup'
require 'repla/logger'
require_relative 'view'

module Repla
  module Log
    # Controller
    class Controller < Repla::Controller
      MESSAGE_PREFIX = Repla::Logger::MESSAGE_PREFIX
      ERROR_PREFIX = Repla::Logger::ERROR_PREFIX

      def initialize
        @view = View.new
      end

      def parse_input(input)
        message = input.dup
        # Don't process blank lines
        message.sub!(/^\s*$\n/, '')
        # Replace multiple spaces
        if message.match?(/^#{MESSAGE_PREFIX}/)
          message[MESSAGE_PREFIX] = ''
          message.rstrip!
          view.log_message(message) unless message.empty?
        elsif message.match?(/^#{ERROR_PREFIX}/)
          message[ERROR_PREFIX] = ''
          message.rstrip!
          view.log_error(message) unless message.empty?
        end
      end
    end
  end
end
