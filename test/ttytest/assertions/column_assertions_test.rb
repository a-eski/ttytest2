# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class ColumnAssertionsTest < Minitest::Test
    def test_assert_column_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column(0, '$$$$$$')
    end

    def test_assert_column_right_success
      @capture = Capture.new("  $\n  $\n  $\n  $\n  $\n  $\n")

      @capture.assert_column(2, '$$$$$$')
    end

    def test_assert_column_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column(0, '$$@$$$')
      end
      assert_includes ex.message, 'expected column 0 to be'
    end

    def test_assert_column_wrong_column_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column(1, '$$$$$$')
      end
      assert_includes ex.message, 'expected column 1 to be'
    end

    def test_assert_column_is_empty_success
      @capture = Capture.new(EMPTY)

      @capture.assert_column_is_empty(0)
      @capture.assert_column_is_empty(1)
      @capture.assert_column_is_empty(2)
      @capture.assert_column_is_empty(3)
      @capture.assert_column_is_empty(4)
      @capture.assert_column_is_empty(5)
      @capture.assert_column_is_empty(6)
      @capture.assert_column_is_empty(7)
    end

    def test_assert_column_is_empty_nothing_in_column_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column_is_empty(1)
      @capture.assert_column_is_empty(2)
      @capture.assert_column_is_empty(3)
      @capture.assert_column_is_empty(4)
      @capture.assert_column_is_empty(5)
      @capture.assert_column_is_empty(6)
      @capture.assert_column_is_empty(7)
    end

    def test_assert_column_is_empty_whitespace_success
      @capture = Capture.new("$ \n$ \n$ \n$ \n$ \n$ \n")

      @capture.assert_column_is_empty(1)
      @capture.assert_column_is_empty(2)
      @capture.assert_column_is_empty(3)
      @capture.assert_column_is_empty(4)
      @capture.assert_column_is_empty(5)
      @capture.assert_column_is_empty(6)
      @capture.assert_column_is_empty(7)
    end

    def test_assert_column_is_empty_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_is_empty(0)
      end
      assert_includes ex.message, 'expected column 0 to be empty'
    end

    def test_assert_column_at_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column_at(0, 0, 5, '$$$$$$')
      @capture.assert_column_at(0, 0, 4, '$$$$$')
      @capture.assert_column_at(0, 0, 3, '$$$$')
      @capture.assert_column_at(0, 0, 2, '$$$')
      @capture.assert_column_at(0, 0, 1, '$$')
      @capture.assert_column_at(0, 0, 0, '$')

      @capture.assert_column_at(0, 1, 5, '$$$$$')
      @capture.assert_column_at(0, 1, 4, '$$$$')
      @capture.assert_column_at(0, 1, 3, '$$$')
      @capture.assert_column_at(0, 1, 2, '$$')
      @capture.assert_column_at(0, 1, 1, '$')

      @capture.assert_column_at(0, 2, 5, '$$$$')
      @capture.assert_column_at(0, 2, 4, '$$$')
      @capture.assert_column_at(0, 2, 3, '$$')
      @capture.assert_column_at(0, 2, 2, '$')

      @capture.assert_column_at(0, 3, 5, '$$$')
      @capture.assert_column_at(0, 3, 4, '$$')
      @capture.assert_column_at(0, 3, 3, '$')

      @capture.assert_column_at(0, 4, 5, '$$')
      @capture.assert_column_at(0, 4, 4, '$')

      @capture.assert_column_at(0, 5, 5, '$')
    end

    def test_assert_column_at_right_success
      @capture = Capture.new("  $\n  $\n  $\n  $\n  $\n  $\n")

      @capture.assert_column_at(2, 0, 5, '$$$$$$')
      @capture.assert_column_at(2, 1, 5, '$$$$$')
      @capture.assert_column_at(2, 1, 4, '$$$$')
      @capture.assert_column_at(2, 2, 5, '$$$$')
      @capture.assert_column_at(2, 2, 4, '$$$')
      @capture.assert_column_at(2, 3, 5, '$$$')
      @capture.assert_column_at(2, 3, 4, '$$')
      @capture.assert_column_at(2, 4, 4, '$')
      @capture.assert_column_at(2, 5, 5, '$')
    end

    def test_assert_column_at_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_at(0, 0, 5, '$$@$$$')
      end
      assert_includes ex.message, 'expected column 0 to be'
    end

    def test_assert_column_at_wrong_column_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_at(1, 0, 3, '$$$$$$')
      end
      assert_includes ex.message, 'expected column 1 to be'
    end
  end
end
