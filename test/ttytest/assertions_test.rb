# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class AssertionsTest < Minitest::Test
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
