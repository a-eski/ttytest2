# frozen_string_literal: true

require 'ttytest/assertions/file_assertions'
require 'ttytest/assertions/row_assertions'
require 'ttytest/assertions/column_assertions'
require 'ttytest/assertions/screen_assertions'
require 'ttytest/assertions/cursor_assertions'

module TTYtest
  # Assertions for ttytest2.
  module Assertions
    include TTYtest::FileAssertions
    include TTYtest::RowAssertions
    include TTYtest::ColumnAssertions
    include TTYtest::ScreenAssertions
    include TTYtest::CursorAssertions

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

    def get_diff_bounded(row_start, row_end, expected)
      expected_rows = expected.split("\n")
      diff = []
      matched = true
      rows.each_with_index do |actual_row, index|
        next if index < row_start
        # break if index >= row_end || actual_row.nil?
        break if index > row_end || actual_row.nil?

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
