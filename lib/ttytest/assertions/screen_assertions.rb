# frozen_string_literal: true

module TTYtest
  # Screen Assertions for ttytest2.
  module ScreenAssertions
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
    # @param [Integer] row_start the row (starting from 0) to test against
    # @param [Integer] row_end the last row to test against
    # @param [String] expected the expected contents of the terminal at specified rows. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents_at(row_start, row_end, expected)
      validate(row_end)

      matched, diff = get_diff(expected, rows[row_start..row_end])

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
  end
end
