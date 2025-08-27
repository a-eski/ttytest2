# frozen_string_literal: true

require 'ttytest/assertions/file_assertions'
require 'ttytest/assertions/row_assertions'
require 'ttytest/assertions/column_assertions'

module TTYtest
  # Assertions for ttytest2.
  module Assertions
    include TTYtest::FileAssertions
    include TTYtest::RowAssertions
    include TTYtest::ColumnAssertions

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

    # Asserts the full contents of the terminal
    # @param [String] expected the full expected contents of the terminal. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents(expected)
      matched, diff = get_diff(expected, rows)

      return if matched

      raise MatchError,
            "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
    end
    alias assert_matches assert_contents
    alias assert_screen assert_contents

    # Asserts the contents of the terminal at specified rows
    # @param [String] expected the expected contents of the terminal at specified rows. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents_at(row_start, row_end, expected)
      validate(row_end)
      row_end += 1 if row_end.zero?

      matched, diff = get_diff(expected, rows.slice(row_start, row_end))

      return if matched

      raise MatchError,
            "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
    end
    alias assert_matches_at assert_contents_at
    alias assert_rows assert_contents_at

    # Asserts the contents of the screen include the passed in string
    # @param [String] expected the string value expected to be found in the screen contents
    # @raise [MatchError] if the screen does not contain the expected value
    def assert_contents_include(expected)
      found = false
      rows.each do |row|
        found = true if row.include?(expected)
      end
      return if found

      raise MatchError,
            "Expected screen contents to include #{expected}, but it was not found.\nEntire screen:\n#{self}"
    end
    alias assert_screen_includes assert_contents_include

    # Asserts the contents of the screen are empty
    # @raise [MatchError] if the screen is not empty
    def assert_contents_empty
      return if rows.all? { |s| s.to_s.empty? }

      raise MatchError,
            "Expected screen to be empty, but found content.\nEntire screen:\n#{self}"
    end
    alias assert_screen_empty assert_contents_empty

    # Asserts the contents of the screen as a single string match the passed in regular expression
    # @param [String] regexp_str the regular expression as a string that will be used to match with
    # @raise [MatchError] if the screen as a string doesn't match against the regular expression
    def assert_contents_match_regexp(regexp_str)
      regexp = Regexp.new(regexp_str)
      screen = capture.to_s

      return if !screen.nil? && screen.match?(regexp)

      raise MatchError,
            "Expected screen contents to match regexp #{regexp_str} but they did not\nEntire screen:\n#{self}"
    end
    alias assert_screen_matches_regexp assert_contents_match_regexp

    METHODS = public_instance_methods

    private

    def get_inspection(actual)
      if actual.nil?
        'nil'
      else
        actual.inspect
      end
    end

    def get_inspection_bounded(actual, column_start, column_end)
      if actual.nil?
        'nil'
      else
        actual[column_start, column_end]
      end
    end

    def validate(row)
      return if @height.nil?
      return unless row >= @height

      raise MatchError,
            "row is at #{row}, which is greater than set height #{height}, so assertions will fail. If intentional, set height larger or break apart tests.\n
            Entire screen:\n#{self}"
    end

    def get_diff(expected, actual)
      expected_rows = expected.split("\n")
      diff = []
      matched = true
      actual.each_with_index do |actual_row, index|
        expected_row = (expected_rows[index] || '').rstrip
        if actual_row != expected_row
          diff << "-#{expected_row}"
          diff << "+#{actual_row}"
          matched = false
        else
          diff << " #{actual_row}".rstrip
        end
      end

      [matched, diff]
    end
  end
end
