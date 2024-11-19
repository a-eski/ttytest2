# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class MatchersTest < Minitest::Test
    EMPTY = "\n" * 23

    def test_assert_row_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row(0, 'foo')
      @capture.assert_row(1, 'bar')
      @capture.assert_row(2, 'baz')
      @capture.assert_row(3, '')
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
      @capture.assert_row(0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row(0, 'foo ')
      @capture.assert_row(0, 'foo  ')
      @capture.assert_row(0, 'foo   ')

      @capture = Capture.new(' foo')
      @capture.assert_row(0, ' foo')
      @capture.assert_row(0, ' foo ')
      assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
    end

    def test_assert_row_at_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_at(0, 0, 1, 'fo')
      @capture.assert_row_at(1, 0, 1, 'ba')
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

    def test_assert_row_at_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_at(0, 0, 0, ' ')
      @capture.assert_row_at(0, 0, 0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row_at(0, 1, 2, 'oo ')
      @capture.assert_row_at(0, 2, 2, 'o  ')
      @capture.assert_row_at(0, 0, 2, 'foo   ')

      @capture = Capture.new(' foo')
      @capture.assert_row_at(0, 0, 2, ' fo')
      @capture.assert_row_at(0, 1, 3, 'foo')
      @capture.assert_row_at(0, 0, 3, ' foo ')
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'bar')
      end
    end

    def test_assert_row_like_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_like(0, 'fo')
      @capture.assert_row_like(1, 'ba')
      @capture.assert_row_like(2, 'az')
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
      @capture.assert_row_like(0, ' ')
      @capture.assert_row_like(0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row_like(0, 'oo ')
      @capture.assert_row_like(0, 'o  ')
      @capture.assert_row_like(0, 'foo   ')

      @capture = Capture.new(' foo')
      @capture.assert_row_like(0, ' fo')
      @capture.assert_row_like(0, 'foo')
      @capture.assert_row_like(0, ' foo ')
      assert_raises TTYtest::MatchError do
        @capture.assert_row_like(0, 'bar')
      end
    end

    def test_assert_row_starts_with_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
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
      @capture.assert_row_starts_with(0, ' ')
      @capture.assert_row_starts_with(0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row_starts_with(0, 'f')
      @capture.assert_row_starts_with(0, 'fo')
      @capture.assert_row_starts_with(0, 'fo  ')

      @capture = Capture.new(' foo')
      @capture.assert_row_starts_with(0, ' f')
      @capture.assert_row_starts_with(0, ' fo ')
      assert_raises TTYtest::MatchError do
        @capture.assert_row_starts_with(0, 'foo')
      end
    end

    def test_assert_row_ends_with_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
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

      @capture = Capture.new(' foo')
      @capture.assert_row_ends_with(0, ' foo')
      @capture.assert_row_ends_with(0, 'foo')
      @capture.assert_row_ends_with(0, 'oo')
      @capture.assert_row_ends_with(0, 'o ')
      assert_raises TTYtest::MatchError do
        @capture.assert_row_ends_with(0, 'bar')
      end
    end

    def test_assert_cursor_position_success
      @capture = Capture.new(EMPTY)
      @capture.assert_cursor_position(0, 0)

      @capture = Capture.new(EMPTY, cursor_y: 2, cursor_x: 1)
      @capture.assert_cursor_position(1, 2)
    end

    def test_assert_cursor_position_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(1, 1)
      end
      assert_includes ex.message, 'expected cursor to be at [1, 1] but was at [0, 0]'

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(0, 0)
      end
      assert_includes ex.message, 'expected cursor to be at [0, 0] but was at [1, 2]'
    end

    def test_assert_contents_success
      @capture = Capture.new(EMPTY)
      @capture.assert_contents('')
      @capture.assert_contents("\n")
      @capture.assert_contents <<TERM
TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world
        Hello, world


      TERM
      @capture.assert_contents <<~TERM
        $ echo "Hello, world
        Hello, world
      TERM
    end

    def test_assert_contents_failure
      @capture = Capture.new("\n\n\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents <<~TERM
          $ echo "Hello, world"
        TERM
      end
      assert_equal ex.message, <<~TERM
        screen did not match expected content:
        --- expected
        +++ actual
        -$ echo "Hello, world"
        +


      TERM
    end

    def test_assert_contents_trailing_whitespace
      @capture = Capture.new(EMPTY)
      @capture.assert_contents(' ')
      @capture.assert_contents('  ')
      @capture.assert_contents("  \n \n")

      @capture = Capture.new('foo')
      @capture.assert_contents('foo')
      @capture.assert_contents('foo  ')
      @capture.assert_contents("foo  \n \n")

      @capture = Capture.new("\nfoo\n")
      @capture.assert_contents("\nfoo")
      @capture.assert_contents("\nfoo  ")
      @capture.assert_contents("  \nfoo \n ")
    end
  end
end
