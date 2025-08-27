# frozen_string_literal: true

module TTYtest
  # File Assertions for ttytest2.
  module FileAssertions
    # Asserts the specified file exists
    # @param [String] file_path the path to the file
    # @raise [MatchError] if the file is not found or is a directory/symlink
    def assert_file_exists(file_path)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)
    end

    # Asserts the specified file does not exists
    # @param [String] file_path the path to the file
    # @raise [MatchError] if the file is found or is a directory/symlink
    def assert_file_doesnt_exist(file_path)
      return unless File.exist?(file_path) || File.file?(file_path)

      raise MatchError,
            "File with path #{file_path} was found or is a directory when it was asserted it did not exist.\nEntire screen:\n#{self}"
    end

    # Asserts the specified file contains the passed in string value
    # @param [String] file_path the path to the file
    # @param [String] needle the value to search for in the file
    # @raise [MatchError] if the file does not contain value in variable needle
    def assert_file_contains(file_path, needle)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)

      file_contains = false
      File.foreach(file_path) do |line|
        if line.include?(needle)
          file_contains = true
          break
        end
      end
      return if file_contains

      raise MatchError,
            "File with path #{file_path} did not contain #{needle}.\nEntire screen:\n#{self}"
    end
    alias assert_file_like assert_file_contains

    # Asserts the specified file has the permissions specified
    # @param [String] file_path the path to the file
    # @param [String] permissions the expected permissions of the file (in form '644' or '775')
    # @raise [MatchError] if the file has different permissions than specified
    def assert_file_has_permissions(file_path, permissions)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)

      file_mode = File.stat(file_path).mode
      perms_octal = format('%o', file_mode)[-3...]
      return if perms_octal == permissions

      raise MatchError,
            "File had permissions #{perms_octal}, not #{permissions} as expected.\n Entire screen:\n#{self}"
    end

    # Asserts the specified file has line count specified
    # @param [String] file_path the path to the file
    # @param [String] expected_count the expected line count of the file
    # @raise [MatchError] if the file has a different line count than specified
    def assert_file_has_line_count(file_path, expected_count)
      raise file_not_found_error(file_path) unless File.exist?(file_path)
      raise file_is_dir_error(file_path) unless File.file?(file_path)

      actual_count = File.foreach(file_path).count
      return if actual_count == expected_count

      raise MatchError,
            "File had #{actual_count} lines, not #{expected_count} lines as expected.\nEntire screen:\n#{self}"
    end

    private

    def file_not_found_error(file_path)
      raise MatchError,
            "File with path #{file_path} was not found when asserted it did exist.\nEntire screen:\n#{self}"
    end

    def file_is_dir_error(file_path)
      raise MatchError,
            "File with path #{file_path} is a directory.\nEntire screen:\n#{self}"
    end
  end
end
