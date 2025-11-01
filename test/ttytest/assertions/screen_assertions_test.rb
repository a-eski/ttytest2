# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class ScreenAssertionsTest < Minitest::Test
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
      @capture.assert_contents("\nfoo ")
      @capture.assert_contents("\nfoo  ")
      @capture.assert_contents("  \nfoo \n ")
    end

    def test_assert_contents_at_success
      @capture = Capture.new(EMPTY)
      @capture.assert_contents_at(0, 0, '')
      @capture.assert_contents_at(0, 0, "\n")
      @capture.assert_contents_at(0, 0, "  \n")
      @capture.assert_contents_at(0, 0, "\n\n\n")

      @capture.assert_contents_at 0, 0, <<TERM
TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world"
        Hello, world


      TERM

      @capture.assert_contents_at(0, 0, '$ echo "Hello, world"')
      @capture.assert_contents_at(1, 1, 'Hello, world')

      @capture.assert_contents_at 0, 0, <<~TERM
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 0, 2, <<~TERM
        $ echo "Hello, world"
        Hello, world

      TERM

      @capture.assert_contents_at 0, 0, <<~TERM
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 1, 1, <<~TERM
        Hello, world
      TERM
    end

    def test_assert_contents_at_success_multiple_lines
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_contents_at(0, 0, 'foo')
      @capture.assert_contents_at(1, 1, 'bar')
      @capture.assert_contents_at(2, 2, 'baz')
      @capture.assert_contents_at 0, 1, <<~TERM
        foo
        bar
      TERM
      # @capture.assert_contents_at 1, 2, <<~TERM
      #   bar
      #   baz
      # TERM
      @capture.assert_contents_at 0, 2, <<~TERM
        foo
        bar
        baz
      TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
        Hello, world
        $
      TERM

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 0, 2, <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 0, 3, <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 1, 1, <<~TERM
        Hello, world
      TERM

      @capture.assert_contents_at 1, 2, <<~TERM
        Hello, world
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 1, 3, <<~TERM
        Hello, world
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 2, 3, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 3, 3, <<~TERM
        Hello, world
      TERM
    end

    def test_assert_contents_at_failure
      @capture = Capture.new("\n\n\n")
      @capture.print_rows
      assert_raises TTYtest::MatchError do
        @capture.assert_contents_at(0, 0, '$ echo "Hello, world"')
      end
    end

    def test_assert_contents_at_row_gt_height_failure
      @capture = Capture.new("\n\n\n", width: 20, height: 4)
      @capture.print_rows
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents_at(0, 5, '$ echo "Hello, world"')
      end
      assert_includes ex.message, 'which is greater than set height'
    end

    def test_assert_contents_at_trailing_whitespace
      @capture = Capture.new(EMPTY)
      @capture.assert_contents_at(0, 0, "\n")
      @capture.assert_contents_at(0, 0, ' ')
      @capture.assert_contents_at(0, 0, '  ')
      @capture.assert_contents_at(0, 0, "  \n \n")

      @capture = Capture.new('foo')
      @capture.assert_contents_at(0, 0, 'foo')
      @capture.assert_contents_at(0, 0, 'foo  ')
      @capture.assert_contents_at(0, 0, "foo  \n \n")

      @capture = Capture.new("\nfoo\n")
      @capture.assert_contents_at(0, 1, "\nfoo ")
      @capture.assert_contents_at(0, 1, "\nfoo  ")
      @capture.assert_contents_at(0, 1, "  \nfoo \n ")
    end

    def test_assert_contents_include_true
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_contents_include('foo')
      @capture.assert_contents_include('bar')
      @capture.assert_contents_include('baz')
    end

    def test_assert_contents_include_false
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents_include('hello')
      end
      assert_includes ex.message, 'Expected screen contents to include'
    end

    def test_assert_contents_empty_true
      @capture = Capture.new(EMPTY)
      @capture.assert_contents_empty
    end

    def test_assert_contents_empty_true_empty_array
      @capture = Capture.new('')
      @capture.assert_contents_empty
    end

    def test_assert_contents_empty_false
      @capture = Capture.new("\n\nHello!\n\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents_empty
      end
      assert_includes ex.message, 'Expected screen to be empty'
    end

    def assert_contents_match_regexp_true
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_contents_match_regexp("foo\nbar\nbaz(?:\n)")
    end

    def assert_contents_match_regexp_false
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents_match_regexp(0, '[foo]')
      end
      assert_includes ex.message, 'Expected screen contents to match regexp'
    end
  end
end
