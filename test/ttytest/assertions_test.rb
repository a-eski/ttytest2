# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class AssertionsTest < Minitest::Test
    def test_assert_cursor_position_success
      @capture = Capture.new(EMPTY)
      @capture.assert_cursor_position(0, 0)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 0)
      @capture.assert_cursor_position(1, 0)

      @capture = Capture.new(EMPTY, cursor_x: 0, cursor_y: 1)
      @capture.assert_cursor_position(0, 1)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
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

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM
    end

    def test_assert_contents_at_success_multiple_lines
      @capture = Capture.new(FOO_BAR_BAZ_THEN_EMPTY)
      @capture.assert_contents_at(0, 0, 'foo')
      @capture.assert_contents_at(1, 1, 'bar')
      @capture.assert_contents_at(2, 2, 'baz')
      @capture.assert_contents_at(0, 1, "foo\nbar")
      @capture.assert_contents_at(1, 2, "bar\nbaz")
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
      TERM

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 1, 2, <<~TERM
        Hello, world
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 0, 3, <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
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

    def test_assert_file_exists_file_exists
      @capture = Capture.new(EMPTY)
      file = './testfile'
      File.new(file, 'w')
      @capture.assert_file_exists(file)
      File.delete(file)
    end

    def test_assert_file_exists_file_doesnt_exist
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_exists('./nonexistant-file')
      end
      assert_includes ex.message, 'was not found'
    end

    def test_assert_file_exists_file_is_directory
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_exists('./test')
      end
      assert_includes ex.message, 'is a directory'
    end

    def test_assert_file_doesnt_exist_file_doesnt_exist
      @capture = Capture.new(EMPTY)
      @capture.assert_file_doesnt_exist('./testfile')
    end

    def test_assert_file_doesnt_exist_file_exists
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_file_doesnt_exist('./Gemfile')
      end
    end

    def test_assert_file_doesnt_exist_file_is_directory
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_file_doesnt_exist('./test')
      end
    end

    def test_assert_file_contains_true
      @capture = Capture.new(EMPTY)
      @capture.assert_file_contains('./Gemfile', 'gemspec')
    end

    def test_assert_file_contains_false
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_file_contains('./Gemfile', 'hello, world!')
      end
    end

    def test_assert_file_contains_file_is_directory
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_contains('./test', 'hello, world!')
      end
      assert_includes ex.message, 'is a directory'
    end

    def test_assert_file_contains_file_doesnt_exist
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_contains('./nonexistant-file', 'hello, world!')
      end
      assert_includes ex.message, 'was not found'
    end

    def test_assert_file_has_permissions_true
      @capture = Capture.new(EMPTY)
      @capture.assert_file_has_permissions('./Gemfile', '644')
    end

    def test_assert_file_has_permissions_false
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_has_permissions('./Gemfile', '775')
      end
      assert_includes ex.message, 'File had permissions 644, not 775 as expected'
    end

    def test_assert_file_has_permissions_file_doesnt_exist
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_has_permissions('./nonexistant-file', '775')
      end
      assert_includes ex.message, 'was not found'
    end

    def test_assert_file_has_line_count_file_is_directory
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_has_line_count('./test', 1)
      end
      assert_includes ex.message, 'is a directory'
    end

    def test_assert_file_has_line_count_file_doesnt_exist
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_contains('./nonexistant-file', 2)
      end
      assert_includes ex.message, 'was not found'
    end

    def test_assert_file_has_line_count_empty_file
      @capture = Capture.new(EMPTY)
      file = './empty_file'
      File.new(file, 'w')
      @capture.assert_file_has_line_count(file, 0)
      File.delete(file)
    end

    def test_assert_file_has_line_count_one_line_file
      @capture = Capture.new(EMPTY)
      file = './one_line_file'
      File.new(file, 'w')
      File.write(file, '1 line')
      @capture.assert_file_has_line_count(file, 1)
      File.delete(file)
    end

    def test_assert_file_has_line_count_gt_zero
      @capture = Capture.new(EMPTY)
      @capture.assert_file_has_line_count('./Gemfile', 5)
    end

    def test_assert_file_has_line_count_mismatch
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_file_has_line_count('./Gemfile', 8)
      end
      assert_includes ex.message, 'lines as expected'
    end
  end
end
