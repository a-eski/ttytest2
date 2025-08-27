# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class RowAssertionsTest < Minitest::Test
    def test_assert_row_success
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row(0, 'foo')
      @capture.assert_row(1, 'bar')
      @capture.assert_row(2, 'baz')
      @capture.assert_row(3, '')
      @capture.assert_row(4, '')
    end

    def test_assert_row_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got ""'
    end

    def test_assert_row_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row(0, ' ')
      @capture.assert_row(0, "\n")
      @capture.assert_row(0, '   ')
      @capture.assert_row(0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row(0, 'foo ')
      @capture.assert_row(0, 'foo  ')
      @capture.assert_row(0, 'foo   ')
      @capture.assert_row(0, "foo\n")

      @capture = Capture.new(' foo')
      @capture.assert_row(0, ' foo ')
      @capture.assert_row(0, ' foo  ')
      @capture.assert_row(0, " foo\n")
      @capture.assert_row(0, " foo  \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
    end

    def test_assert_row_nil_failure
      @capture = Capture.new(nil)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got ""'
    end

    def test_assert_row_row_gt_height
      @capture = Capture.new('', width: 20, height: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(2, 'foo')
      end
      assert_includes ex.message, 'which is greater than set height'
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(5, 'foo')
      end
      assert_includes ex.message, 'which is greater than set height'
    end

    def test_assert_row_is_empty_success
      @capture = Capture.new(EMPTY)
      @capture.assert_row_is_empty(0)
      @capture.assert_row_is_empty(1)
      @capture.assert_row_is_empty(2)
      @capture.assert_row_is_empty(3)
      @capture.assert_row_is_empty(4)
    end

    def test_assert_row_is_empty_failure
      @capture = Capture.new("foo\nfoo\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row_is_empty(0)
      end
      assert_includes ex.message, 'expected row 0 to be empty'
    end

    def test_assert_row_is_empty_row_gt_height_failure
      @capture = Capture.new("foo\nfoo\n", width: 20, height: 5)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row_is_empty(5)
      end
      assert_includes ex.message, 'which is greater than set height'
    end

    def test_assert_row_at_success
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row_at(0, 0, 0, 'f')
      @capture.assert_row_at(0, 0, 1, 'fo')
      @capture.assert_row_at(0, 0, 2, 'foo')
      @capture.assert_row_at(0, 1, 2, 'oo')
      @capture.assert_row_at(0, 2, 2, 'o')

      @capture.assert_row_at(1, 0, 0, 'b')
      @capture.assert_row_at(1, 0, 1, 'ba')
      @capture.assert_row_at(1, 0, 2, 'bar')
      @capture.assert_row_at(1, 1, 2, 'ar')
      @capture.assert_row_at(1, 2, 2, 'r')

      @capture.assert_row_at(2, 0, 0, 'b')
      @capture.assert_row_at(2, 0, 1, 'ba')
      @capture.assert_row_at(2, 0, 2, 'baz')
      @capture.assert_row_at(2, 1, 2, 'az')
      @capture.assert_row_at(2, 2, 2, 'z')

      @capture.assert_row_at(3, 0, 0, '')
    end

    def test_assert_row_at_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'foo')
      end
    end

    def test_assert_row_at_nil_failure
      @capture = Capture.new(nil)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'foo')
      end
    end

    def test_assert_row_at_row_gt_height_failure
      @capture = Capture.new(EMPTY, width: 20, height: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row_at(2, 0, 2, 'foo')
      end
      assert_includes ex.message, 'which is greater than set height'
    end

    def test_assert_row_at_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_at(0, 0, 0, "\n")
      @capture.assert_row_at(0, 0, 0, ' ')
      @capture.assert_row_at(0, 0, 0, '   ')
      @capture.assert_row_at(0, 0, 0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row_at(0, 1, 2, "oo\n")
      @capture.assert_row_at(0, 1, 2, 'oo ')
      @capture.assert_row_at(0, 2, 2, 'o  ')
      @capture.assert_row_at(0, 0, 2, 'foo   ')
      @capture.assert_row_at(0, 0, 2, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_at(0, 0, 2, ' fo')
      @capture.assert_row_at(0, 0, 2, ' fo ')
      @capture.assert_row_at(0, 1, 3, 'foo ')
      @capture.assert_row_at(0, 1, 3, "foo\n")
      @capture.assert_row_at(0, 0, 3, ' foo ')
      @capture.assert_row_at(0, 0, 3, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'bar')
      end
    end

    def test_assert_row_like_success
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row_like(0, 'fo')
      @capture.assert_row_like(0, 'oo')
      @capture.assert_row_like(0, 'f')
      @capture.assert_row_like(1, 'ba')
      @capture.assert_row_like(1, 'ar')
      @capture.assert_row_like(1, 'a')
      @capture.assert_row_like(2, 'az')
      @capture.assert_row_like(2, 'ba')
      @capture.assert_row_like(2, 'z')
      @capture.assert_row_like(3, '')
    end

    def test_assert_row_like_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_like(0, 'foo')
      end
    end

    def test_assert_row_like_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_like(0, "\n")
      @capture.assert_row_like(0, ' ')
      @capture.assert_row_like(0, '   ')
      @capture.assert_row_like(0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row_like(0, 'oo ')
      @capture.assert_row_like(0, 'o  ')
      @capture.assert_row_like(0, 'foo   ')
      @capture.assert_row_like(0, "foo\n")
      @capture.assert_row_like(0, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_like(0, ' fo ')
      @capture.assert_row_like(0, 'foo ')
      @capture.assert_row_like(0, ' foo ')
      @capture.assert_row_like(0, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_like(0, 'bar')
      end
    end

    def test_assert_row_starts_with_success
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row_starts_with(0, 'f')
      @capture.assert_row_starts_with(0, 'fo')
      @capture.assert_row_starts_with(0, 'foo')

      @capture.assert_row_starts_with(1, 'b')
      @capture.assert_row_starts_with(1, 'ba')
      @capture.assert_row_starts_with(1, 'bar')

      @capture.assert_row_starts_with(2, 'b')
      @capture.assert_row_starts_with(2, 'ba')
      @capture.assert_row_starts_with(2, 'baz')

      @capture.assert_row_starts_with(3, '')
    end

    def test_assert_row_starts_with_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_starts_with(0, 'bar')
      end
    end

    def test_assert_row_starts_with_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_starts_with(0, "\n")
      @capture.assert_row_starts_with(0, "  \n")
      @capture.assert_row_starts_with(0, ' ')
      @capture.assert_row_starts_with(0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row_starts_with(0, 'f ')
      @capture.assert_row_starts_with(0, "f  \n")
      @capture.assert_row_starts_with(0, 'fo ')
      @capture.assert_row_starts_with(0, 'fo  ')

      @capture = Capture.new(' foo')
      @capture.assert_row_starts_with(0, ' f ')
      @capture.assert_row_starts_with(0, ' fo ')
      @capture.assert_row_starts_with(0, ' foo ')
      @capture.assert_row_starts_with(0, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_starts_with(0, 'foo')
      end
    end

    def test_assert_row_ends_with_success
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row_ends_with(0, 'o')
      @capture.assert_row_ends_with(0, 'oo')
      @capture.assert_row_ends_with(0, 'foo')

      @capture.assert_row_ends_with(1, 'r')
      @capture.assert_row_ends_with(1, 'ar')
      @capture.assert_row_ends_with(1, 'bar')

      @capture.assert_row_ends_with(2, 'z')
      @capture.assert_row_ends_with(2, 'az')
      @capture.assert_row_ends_with(2, 'baz')

      @capture.assert_row_ends_with(3, '')
    end

    def test_assert_row_ends_with_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_ends_with(0, 'bar')
      end
    end

    def test_assert_row_ends_with_trailing_whitespace
      @capture = Capture.new('foo')
      @capture.assert_row_ends_with(0, 'o ')
      @capture.assert_row_ends_with(0, 'oo  ')
      @capture.assert_row_ends_with(0, 'foo   ')
      @capture.assert_row_ends_with(0, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_ends_with(0, ' foo ')
      @capture.assert_row_ends_with(0, 'foo ')
      @capture.assert_row_ends_with(0, 'oo ')
      @capture.assert_row_ends_with(0, 'o ')
      @capture.assert_row_ends_with(0, "o \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_ends_with(0, 'bar')
      end
    end

    def test_assert_row_regexp_success
      @capture = Capture.new(EMPTY)
      @capture.assert_row_regexp(0, '')

      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_row_regexp(0, 'foo')
      @capture.assert_row_regexp(0, '[o]')
      @capture.assert_row_regexp(1, 'bar')
      @capture.assert_row_regexp(1, '[a]')
      @capture.assert_row_regexp(2, 'baz')
      @capture.assert_row_regexp(2, '[z]')
      @capture.assert_row_regexp(3, '')
    end

    def test_assert_row_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_regexp(0, '[o]')
      end
    end

    def test_assert_rows_each_match_regexp_success
      @capture = Capture.new(EMPTY)

      @capture = Capture.new("foo\nfoo\nfoo\n")
      @capture.assert_rows_each_match_regexp(0, 2, 'foo')
      @capture.assert_rows_each_match_regexp(0, 2, '[o]')
      @capture.assert_rows_each_match_regexp(0, 2, '[f]')
    end

    def test_assert_rows_each_match_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, '[o]')
      end

      @capture = Capture.new("foo\nfoo\nfoo\n")

      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, '[a]')
      end

      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, 'ba\]')
      end
    end
  end
end
