#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ttytest'

START_COL = 19

def assert_check_new_row(row)
  @tty.assert_row_starts_with(row, "#{ENV['USER']}:")
  @tty.assert_row_like(row, 'ncsh')
  @tty.assert_row_ends_with(row, '$')
  @tty.assert_cursor_position(START_COL, row)
end

@tty = TTYtest.new_terminal(%(PS1='$ ' ./bin/ncsh), width: 80, height: 24)

row = 0

# # # # Basic Tests # # # #
puts 'Starting basic tests'

@tty.assert_row_starts_with(row, 'ncsh: startup time: ')
row += 1

assert_check_new_row(row)
@tty.send_keys_one_at_a_time(%(ls))
@tty.assert_cursor_position(START_COL + 2, 1)
@tty.send_newline
@tty.assert_row_ends_with(row, 'ls')
row += 1
@tty.assert_row_starts_with(row, 'LICENSE')
row = 9

assert_check_new_row(row)
@tty.send_keys_one_at_a_time(%(echo hello))
@tty.send_newline
row += 1
@tty.assert_row(row, 'hello')
row += 1

assert_check_new_row(row)
@tty.send_keys_one_at_a_time(%(lss)) # send a bad command
@tty.send_newline
row += 1
@tty.assert_row(row, 'ncsh: Could not find command or directory: No such file or directory')
row += 1

puts 'Starting backspace tests'

# end of line backspace
assert_check_new_row(row)
@tty.send_keys_one_at_a_time(%(l))
@tty.send_backspace
assert_check_new_row(row)

# multiple end of line backspaces
@tty.send_keys_one_at_a_time(%(lsssss))
@tty.send_backspace
@tty.send_backspace
@tty.send_backspace
@tty.send_backspace
@tty.assert_row_ends_with(row, '$ ls')
@tty.send_backspace
@tty.send_backspace
@tty.send_keys_one_at_a_time(%(echo hello)) # make sure buffer is properly formed after backspaces
@tty.send_newline
row += 1
@tty.assert_row(row, 'hello')
row += 1

# midline backspace
assert_check_new_row(row)
@tty.send_keys_one_at_a_time(%(lsssss))
@tty.assert_cursor_position(START_COL + 6, row)
@tty.send_keys(TTYtest::LEFT_ARROW)
@tty.send_keys(TTYtest::LEFT_ARROW)
@tty.assert_cursor_position(START_COL + 4, row)
@tty.send_backspace
@tty.send_backspace
@tty.send_backspace
@tty.send_backspace
@tty.assert_cursor_position(START_COL, row)
@tty.assert_row_ends_with(row, '$ ss')
@tty.send_keys(TTYtest::RIGHT_ARROW)
@tty.send_keys(TTYtest::RIGHT_ARROW)
@tty.assert_cursor_position(START_COL + 2, row)
@tty.send_backspace
@tty.send_backspace
@tty.assert_cursor_position(START_COL, row)
@tty.send_keys_one_at_a_time(%(echo hello)) # make sure buffer is properly formed after backspaces
@tty.send_newline
row += 1
@tty.assert_row(row, 'hello')
