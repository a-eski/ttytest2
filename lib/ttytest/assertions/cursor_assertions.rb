# frozen_string_literal: true

module TTYtest
  # Cursor Assertions for ttytest2.
  module CursorAssertions
    # Asserts that the cursor is in the expected position
    # @param [Integer] x cursor x (row) position, starting from 0
    # @param [Integer] y cursor y (column) position, starting from 0
    # @raise [MatchError] if the cursor position doesn't match
    def assert_cursor_position(x, y)
      expected = [x, y]
      actual = [cursor_x, cursor_y]

      return if actual == expected

      raise MatchError,
            "expected cursor to be at #{expected.inspect} but was at #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # Asserts the cursor is currently visible
    # @raise [MatchError] if the cursor is hidden
    def assert_cursor_visible
      return if cursor_visible?

      raise MatchError, "expected cursor to be visible was hidden\nEntire screen:\n#{self}"
    end

    # Asserts the cursor is currently hidden
    # @raise [MatchError] if the cursor is visible
    def assert_cursor_hidden
      return if cursor_hidden?

      raise MatchError, "expected cursor to be hidden was visible\nEntire screen:\n#{self}"
    end
  end
end
