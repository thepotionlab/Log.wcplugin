#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_constants'

require_relative '../bundle/bundler/setup'
require 'repla/logger'

require 'repla/test'
require Repla::Test::HELPER_FILE
require Repla::Test::REPLA_FILE

require_relative 'lib/test_helper'

# Test plugin
class TestPlugin < Minitest::Test
  MESSAGE_PREFIX = Repla::Logger::MESSAGE_PREFIX
  ERROR_PREFIX = Repla::Logger::ERROR_PREFIX

  def setup
    Repla.load_plugin(TEST_PLUGIN_PATH)
    window_id = Repla.run_plugin(TEST_PLUGIN_NAME, TEST_PLUGIN_PATH)
    @window = Repla::Window.new(window_id)
    @test_helper = Repla::Log::Tests::TestHelper.new(@window)
  end

  # Tests

  def test_log_title
    sleep Repla::Test::TEST_PAUSE_TIME # Give the plugin time to finish running
    title = @window.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert_equal(title, TEST_PLUGIN_NAME)
  end

  def test_log
    # Test Error
    message = 'Testing log error'
    input = ERROR_PREFIX + message
    @window.read_from_standard_input(input + "\n")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('error', test_class, 'The classes should match')

    # Test Message
    message = 'Testing log message'
    input = MESSAGE_PREFIX + message
    @window.read_from_standard_input(input + "\n")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test No Prefix
    @window.read_from_standard_input('Testing no prefix' + "\n")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Blank Spaces
    @window.read_from_standard_input("  \t" + "\n")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')

    # Test Empty String
    @window.read_from_standard_input('' + "\n")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = @test_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')
  end
end
