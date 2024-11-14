# frozen_string_literal: true

# some constants that can be used with send_keys, just to help out people creating tests
# may not work with all terminal emulators
module TTYtest
  BACKSPACE = 'BSpace'
  DELETE = 'DC'
  TAB = 'Tab'
  CTRLF = 6.chr
  CTRLC = 3.chr
  CTRLD = '\004'
  ESCAPE_CHARACTER = 27.chr
  ESCAPE = 'Escape'
  ENTER = 'Enter'
  NEWLINE = "\n"
  SPACE = 'Space'

  UP_ARROW = 'Up'
  DOWN_ARROW = 'Down'
  RIGHT_ARROW = 'Right'
  LEFT_ARROW = 'Left'
  HOME_KEY = 'Home'
  END_KEY = 'End'
  INSERT = 'IC'

  CLEAR = 'clear'

  F1 = 'F1'
  F2 = 'F2'
  F3 = 'F3'
  F4 = 'F4'
  F5 = 'F5'
  F6 = 'F6'
  F7 = 'F7'
  F8 = 'F8'
  F9 = 'F9'
  F10 = 'F10'
  F11 = 'F11'
  F12 = 'F12'
end
