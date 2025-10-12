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

    def test_assert_column_nil_failure
      @capture = Capture.new(nil)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column(0, 'foo')
      end
      assert_includes ex.message, 'expected column 0 to be "foo"'
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

    def test_assert_column_like_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column_like(0, '$$$$$$')
      @capture.assert_column_like(0, '$$$$$')
      @capture.assert_column_like(0, '$$$$')
      @capture.assert_column_like(0, '$$$')
      @capture.assert_column_like(0, '$$')
      @capture.assert_column_like(0, '$')
    end

    def test_assert_column_like_right_success
      @capture = Capture.new("  $\n  $\n  $\n  $\n  $\n  $\n")

      @capture.assert_column_like(2, '$$$$$$')
      @capture.assert_column_like(2, '$$$$$')
      @capture.assert_column_like(2, '$$$$')
      @capture.assert_column_like(2, '$$$$')
      @capture.assert_column_like(2, '$$$')
      @capture.assert_column_like(2, '$$$')
      @capture.assert_column_like(2, '$$')
      @capture.assert_column_like(2, '$')
    end

    def test_assert_column_like_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_like(0, '@')
      end
      assert_includes ex.message, 'expected column 0 to be like'
    end

    def test_assert_column_like_wrong_column_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_like(1, '$$$$$$')
      end
      assert_includes ex.message, 'expected column 1 to be like'
    end

    def test_assert_column_starts_with_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column_starts_with(0, '$$$$$$')
      @capture.assert_column_starts_with(0, '$$$$$')
      @capture.assert_column_starts_with(0, '$$$$')
      @capture.assert_column_starts_with(0, '$$$')
      @capture.assert_column_starts_with(0, '$$')
      @capture.assert_column_starts_with(0, '$')
    end

    def test_assert_column_starts_with_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_starts_with(0, '@')
      end
      assert_includes ex.message, 'expected column 0 to start with'
    end

    def test_assert_column_ends_with_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      @capture.assert_column_ends_with(0, '$$$$$$')
      @capture.assert_column_ends_with(0, '$$$$$')
      @capture.assert_column_ends_with(0, '$$$$')
      @capture.assert_column_ends_with(0, '$$$')
      @capture.assert_column_ends_with(0, '$$')
      @capture.assert_column_ends_with(0, '$')
    end

    def test_assert_column_ends_with_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      ex = assert_raises TTYtest::MatchError do
        @capture.assert_column_ends_with(0, '@')
      end
      assert_includes ex.message, 'expected column 0 to end with'
    end

    def test_assert_column_regexp_success
      @capture = Capture.new(EMPTY)
      @capture.assert_column_regexp(0, '')

      @capture = Capture.new("foob\noooa\noofr")
      @capture.assert_column_regexp(0, 'foo')
      @capture.assert_column_regexp(0, '[f]')
      @capture.assert_column_regexp(0, '[o]')
      @capture.assert_column_regexp(0, '[fo]')
      @capture.assert_column_regexp(2, '[of]')
      @capture.assert_column_regexp(3, 'bar')
      @capture.assert_column_regexp(3, '[b]')
      @capture.assert_column_regexp(3, '[a]')
      @capture.assert_column_regexp(3, '[r]')
      @capture.assert_column_regexp(3, '')
    end

    def test_assert_column_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_column_regexp(0, '[o]')
      end
    end

    def test_assert_columns_each_match_regexp_success
      @capture = Capture.new(EMPTY)

      @capture = Capture.new("foo\nofo\noof\n")
      @capture.assert_columns_each_match_regexp(0, 2, '[o]')
      @capture.assert_columns_each_match_regexp(0, 2, '[f]')
      @capture.assert_columns_each_match_regexp(0, 2, '[fo]')
    end

    def test_assert_columns_each_match_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_columns_each_match_regexp(0, 2, '[o]')
      end

      @capture = Capture.new("foo\nfoo\nfoo\n")

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_each_match_regexp(0, 2, '[a]')
      end

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_each_match_regexp(0, 2, 'ba\]')
      end
    end

    def test_assert_columns_match_regexp_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")
      @capture.assert_columns_match_regexp(0, 5, '$*\n*')
      @capture.assert_columns_match_regexp(0, 4, '$*\n*')
      @capture.assert_columns_match_regexp(0, 3, '$*\n*')
      @capture.assert_columns_match_regexp(0, 2, '$*\n*')
      @capture.assert_columns_match_regexp(0, 1, '$*\n*')
      @capture.assert_columns_match_regexp(0, 0, '$*\n*')
      @capture.assert_columns_match_regexp(1, 5, '$*\n*')
      @capture.assert_columns_match_regexp(2, 5, '$*\n*')
      @capture.assert_columns_match_regexp(3, 5, '$*\n*')
      @capture.assert_columns_match_regexp(4, 5, '$*\n*')
      @capture.assert_columns_match_regexp(5, 5, '$*\n*')
    end

    def test_assert_columns_match_regexp_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_match_regexp(0, 5, '@')
      end

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_match_regexp(0, 5, '[@]')
      end
    end

    def test_assert_columns_match_regexp_remove_newlines_success
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")
      @capture.assert_columns_match_regexp(0, 5, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(0, 4, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(0, 3, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(0, 2, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(0, 1, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(0, 0, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(1, 5, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(2, 5, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(3, 5, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(4, 5, '$*', remove_newlines: true)
      @capture.assert_columns_match_regexp(5, 5, '$*', remove_newlines: true)
    end

    def test_assert_columns_match_regexp_remove_newlines_failure
      @capture = Capture.new("$\n$\n$\n$\n$\n$\n")

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_match_regexp(0, 5, '@', remove_newlines: true)
      end

      assert_raises TTYtest::MatchError do
        @capture.assert_columns_match_regexp(0, 5, '[@]', remove_newlines: true)
      end
    end
  end
end
