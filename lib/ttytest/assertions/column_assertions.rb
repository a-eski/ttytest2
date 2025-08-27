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
  end
end
