#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative '../bundle/bundler/setup'
require 'repla/logger'

require 'repla/test'
require Repla::Test::REPLA_FILE

require_relative 'lib/test_helper'
require_relative '../lib/controller'

# Test view
class TestView < Minitest::Test
  MESSAGE_PREFIX = Repla::Logger::MESSAGE_PREFIX
  ERROR_PREFIX = Repla::Logger::ERROR_PREFIX

  def setup
    @controller = Repla::Log::Controller.new
    @test_helper = Repla::Log::Test::TestHelper.new(@controller.view)
  end

  def teardown
    @controller.view.close
  end

  def test_controller
    # Test Error
    message = 'Testing log error'
    input = ERROR_PREFIX + message
    @controller.parse_input(input)
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('error', test_class, 'The classes should match')

    # Test Message
    message = 'Testing log message'
    input = MESSAGE_PREFIX + message
    @controller.parse_input(input)
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test No Prefix
    @controller.parse_input('Testing no prefix')
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Only Prefix
    @controller.parse_input(MESSAGE_PREFIX)
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Prefix & Whitespace
    @controller.parse_input(MESSAGE_PREFIX + ' ')
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Blank Spaces
    @controller.parse_input("  \t")
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Empty String
    @controller.parse_input('')
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Multiple Spaces
    message = '|   |'
    input = MESSAGE_PREFIX + message
    @controller.parse_input(input)
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')
  end
end
