# frozen_string_literal: true

module TTYtest
  # Row Assertions for ttytest2.
  module RowAssertions
    # Asserts the contents of a single row match the value expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value of the row. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match exactly
    def assert_row(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual == expected

      raise MatchError,
            "expected row #{row_number} to be #{expected.inspect} but got #{get_inspection(actual)}\n
            Entire screen:\n#{self}"
    end
    alias assert_line assert_row

    # Asserts the specified row is empty
    # @param [Integer] row_number the row (starting from 0) to test against
    # @raise [MatchError] if the row isn't empty
    def assert_row_is_empty(row_number)
      validate(row_number)
      actual = row(row_number)

      return if actual == ''

      raise MatchError,
            "expected row #{row_number} to be empty but got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_line_is_empty assert_row_is_empty

    # Asserts the contents of a row contain the expected string at the specified position
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [Integer] column_start the column position to start comparing expected against
    # @param [Integer] columns_end the column position to end comparing expected against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_at(row_number, column_start, column_end, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)
      column_end += 1

      return if !actual.nil? && actual[column_start, column_end].eql?(expected)

      inspection = get_inspection_bounded(actual, column_start, column_end)

      raise MatchError,
            "expected row #{row_number} to contain #{expected} at #{column_start}-#{column_end} and got #{inspection}\nEntire screen:\n#{self}"
    end
    alias assert_line_at assert_row_at

    # Asserts the contents of a single row contains the value expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value contained in the row. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_like(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.include?(expected)

      raise MatchError,
            "expected row #{row_number} to be like #{expected.inspect} but got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_row_contains assert_row_like
    alias assert_line_contains assert_row_like
    alias assert_line_like assert_row_like

    # Asserts the contents of a single row starts with expected string
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_starts_with(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.start_with?(expected)

      raise MatchError,
            "expected row #{row_number} to start with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_line_starts_with assert_row_starts_with

    # Asserts the contents of a single row ends with expected
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row_ends_with(row_number, expected)
      validate(row_number)
      expected = expected.rstrip
      actual = row(row_number)

      return if !actual.nil? && actual.end_with?(expected)

      raise MatchError,
            "expected row #{row_number} to end with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_line_ends_with assert_row_ends_with

    # Asserts the contents of a single row match against the passed in regular expression
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] regexp_str the regular expression as a string that will be used to match with.
    # @raise [MatchError] if the row doesn't match against the regular expression
    def assert_row_regexp(row_number, regexp_str)
      validate(row_number)
      regexp = Regexp.new(regexp_str)
      actual = row(row_number)

      return if !actual.nil? && actual.match?(regexp)

      raise MatchError,
            "expected row #{row_number} to match regexp #{regexp_str} but it did not. Row value #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_line_regexp assert_row_regexp

    # Asserts the contents of a multiple rows each match against the passed in regular expression
    # @param [Integer] row_start the row (starting from 0) to test against
    # @param [Integer] row_end the last row to test against
    # @param [String] regexp_str the regular expression as a string that will be used to match with.
    # @raise [MatchError] if a row doesn't match against the regular expression
    def assert_rows_each_match_regexp(row_start, row_end, regexp_str)
      validate(row_end)
      regexp = Regexp.new(regexp_str)
      row_end += 1 if row_end.zero?

      rows.slice(row_start, row_end).each_with_index do |actual_row, index|
        next if !actual_row.nil? && actual_row.match?(regexp)

        raise MatchError,
              "expected row #{index} to match regexp #{regexp_str} but it did not. Row value #{get_inspection(actual_row)}\nEntire screen:\n#{self}"
      end
    end
    alias assert_lines_each_match_regexp assert_rows_each_match_regexp

    # Asserts the contents of multiple rows match the passed in regular expression.
    # @param [Integer] row_start the row (starting from 0) to test against
    # @param [Integer] row_end the last row to test against
    # @param [String] regexp_str the regular expression as a string that will be used to match with.
    # @param [bool] remove_newlines an optional paramter to specify if line separators should be removed, defaults to false
    # @raise [MatchError] if the rows don't match against the regular expression
    def assert_rows_match_regexp(row_start, row_end, regexp_str, remove_newlines: false)
      validate(row_end)
      regexp = Regexp.new(regexp_str)
      row_end += 1 if row_end.zero?

      slices = rows.slice(row_start, row_end)
      if remove_newlines
        slices.each_with_index do |slice, i|
          slices[i] = slice.rstrip
        end
      end
      actual = slices.join

      return if !actual.nil? && actual.match?(regexp)

      raise MatchError,
            "expected rows #{row_start}-#{row_end} to match regexp #{regexp_str} but they did not. Rows value #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_lines_match_regexp assert_rows_match_regexp
  end
end
