# frozen_string_literal: true

module TTYtest
  module Tmux
    # represents a tmux session and how to send output to the current tmux session
    class Session
      # @api private
      def initialize(driver, name)
        @driver = driver
        @name = name

        # ObjectSpace.define_finalizer(self, self.class.finalize(driver, name))
      end

      # @api private
      # def self.finalize(driver, name)
      #   proc { driver.tmux(*%W[kill-session -t #{name}]) }
      # end

      def capture
        contents = driver.tmux(*%W[capture-pane -t #{name} -p])
        str = driver.tmux(*%W[display-message -t #{name} -p
                              #\{cursor_x},#\{cursor_y},#\{cursor_flag},#\{pane_width},#\{pane_height},#\{pane_dead},#\{pane_dead_status},])
        x, y, cursor_flag, width, height, pane_dead, pane_dead_status, _newline = str.split(',')

        if pane_dead == '1'
          raise Driver::TmuxError,
                "Tmux pane has died\nCommand exited with status: #{pane_dead_status}\nEntire screen:\n#{contents}"
        end

        TTYtest::Capture.new(
          contents.chomp("\n"),
          cursor_x: x.to_i,
          cursor_y: y.to_i,
          width: width.to_i,
          height: height.to_i,
          cursor_visible: (cursor_flag != '0')
        )
      end

      # Send the array of keys as a string literal to tmux.
      # Will not be interpreted as send-keys values like Enter, Escape, DC for Delete, etc.
      # @param [%w()] keys the keys to send to tmux
      def send_keys(*keys)
        driver.tmux(*%W[send-keys -t #{name} -l], *keys)
      end

      # Send a string of keys one character at a time as literals to tmux.
      # @param [String] keys the keys to send one at a time to tmux
      def send_keys_one_at_a_time(keys)
        keys.split('').each do |key|
          driver.tmux(*%W[send-keys -t #{name} -l], key)
        end
      end

      def send_newline
        driver.tmux(*%W[send-keys -t #{name} -l], %(\n))
      end

      def send_delete
        send_keys_exact(%(DC))
      end

      def send_backspace
        send_keys_exact(%(BSpace))
      end

      # Useful to send send-keys commands to tmux without sending them as a string literal.
      # So you can send Escape for escape key, DC for delete, etc.
      # Uses the same key bindings as bind-key as well. C-c represents Ctrl + C keys, F1 is F1 key, etc.
      # @param [String] keys the keys to send to tmux
      def send_keys_exact(keys)
        driver.tmux(*%W[send-keys -t #{name}], keys)
      end

      private

      attr_reader :driver, :name
    end
  end
end
