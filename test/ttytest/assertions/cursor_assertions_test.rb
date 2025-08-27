# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class CursorAssertionsTest < Minitest::Test
    def test_assert_cursor_position_success
      @capture = Capture.new(EMPTY)
      @capture.assert_cursor_position(0, 0)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 0)
      @capture.assert_cursor_position(1, 0)

      @capture = Capture.new(EMPTY, cursor_x: 0, cursor_y: 1)
      @capture.assert_cursor_position(0, 1)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      @capture.assert_cursor_position(1, 2)
    end

    def test_assert_cursor_position_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(1, 1)
      end
      assert_includes ex.message, 'expected cursor to be at [1, 1] but was at [0, 0]'

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(0, 0)
      end
      assert_includes ex.message, 'expected cursor to be at [0, 0] but was at [1, 2]'
    end
  end
end
