# frozen_string_literal: true

module TTYtest
  # Column Assertions for ttytest2.
  module ColumnAssertions
    # Asserts the contents of a single column match the value expected
    # @param [Integer] col_number the column (starting from 0) to test against
    # @param [String] expected the expected value of the column. Any trailing whitespace is ignored
    # @raise [MatchError] if the column doesn't match exactly
    def assert_column(col_number, expected)
      validate(col_number)
      expected = expected.rstrip

      rows.each_with_index do |row, i|
        break if row.nil?

        next if row[col_number] == expected[i]

        raise MatchError,
              "expected column #{col_number} to be #{expected.inspect}\n
            Entire screen:\n#{self}"
      end
    end

    # Asserts the specified column is empty
    # @param [Integer] col_number the column (starting from 0) to test against
    # @raise [MatchError] if the column isn't empty
    def assert_column_is_empty(col_number)
      validate(col_number)

      rows.each do |row|
        break if row.nil?

        next if row == '' || row.length < col_number + 1 || row[col_number] == ' '

        raise MatchError,
              "expected column #{col_number} to be empty\nEntire screen:\n#{self}"
      end
    end

    # Asserts the contents of a column contain the expected string at the specified position
    # @param [Integer] col_number the column (starting from 0) to test against
    # @param [Integer] row_start the row position to start comparing expected against
    # @param [Integer] row_end the row position to end comparing expected against (inclusive)
    # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the column doesn't match
    def assert_column_at(col_number, row_start, row_end, expected)
      validate(col_number)
      expected = expected.rstrip
      actual = []

      rows.each_with_index do |row, i|
        next if i < row_start
        break if i > row_end || row.nil?

        actual[i - row_start] = row[col_number]
        next if row[col_number] == expected[i - row_start]

        raise MatchError,
              "expected column #{col_number} to be #{expected.inspect}\n
            Entire screen:\n#{self}"
      end

      return if !actual.nil? && actual.join.eql?(expected)

      inspection = get_inspection(actual.join)

      raise MatchError,
            "expected column #{col_number} to contain #{expected} at #{row_start}-#{row_end} and got #{inspection}\nEntire screen:\n#{self}"
    end

    # Asserts the contents of a single column contains the value expected
    # @param [Integer] col_number the column number (starting from 0) to test against
    # @param [String] expected the expected value contained in the column. Any trailing whitespace is ignored
    # @raise [MatchError] if the column doesn't match
    def assert_column_like(col_number, expected)
      validate(col_number)
      expected = expected.rstrip
      actual = get_column(col_number).join

      return if !actual.nil? && actual.include?(expected)

      raise MatchError,
            "expected column #{col_number} to be like #{expected.inspect} but got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end
    alias assert_column_contains assert_column_like

    # Asserts the contents of a single column starts with expected string
    # @param [Integer] col_number the column (starting from 0) to test against
    # @param [String] expected the expected value that the column starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the column doesn't match
    def assert_column_starts_with(col_number, expected)
      validate(col_number)
      expected = expected.rstrip
      actual = get_column(col_number).join

      return if !actual.nil? && actual.start_with?(expected)

      raise MatchError,
            "expected column #{col_number} to start with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    # Asserts the contents of a column ends with expected
    # @param [Integer] col_number the column (starting from 0) to test against
    # @param [String] expected the expected value that the column starts with. Any trailing whitespace is ignored
    # @raise [MatchError] if the column doesn't match
    def assert_column_ends_with(col_number, expected)
      validate(col_number)
      expected = expected.rstrip
      actual = get_column(col_number).join

      return if !actual.nil? && actual.end_with?(expected)

      raise MatchError,
            "expected column #{col_number} to end with #{expected.inspect} and got #{get_inspection(actual)}\nEntire screen:\n#{self}"
    end

    private

    def get_column(col_number)
      actual = []

      rows.each_with_index do |row, i|
        break if row.nil?

        actual[i] = row[col_number]
      end

      actual
    end
  end
end
