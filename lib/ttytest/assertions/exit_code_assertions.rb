# frozen_string_literal: true

module TTYtest
  # Exit Code Assertions for ttytest2. Not finished and added yet.
  module ExitCodeAssertions
    # Asserts that the exit code of the previous command matches the specified value
    # Note: if you are tracking current row in your tests, this command will take up 2 lines.
    # It echos the previous commands exit code to the screen and then reads it from there
    # @param [Integer] code the expected exit code
    # @raise [MatchError] if the exit code found does not match specified value
    def assert_exit_code(code) end
  end
end
