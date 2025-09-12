# frozen_string_literal: true

require 'open3'
require 'securerandom'
require 'English'

require 'ttytest/terminal'
require 'ttytest/tmux/session'

module TTYtest
  module Tmux
    # tmux driver
    class Driver
      COMMAND = 'tmux'
      SOCKET_NAME = 'ttytest'
      REQUIRED_TMUX_VERSION = '1.8'
      DEFAULT_CONFING_FILE_PATH = File.expand_path('tmux.conf', __dir__)
      SLEEP_INFINITY = 'read x < /dev/fd/1'

      class TmuxError < StandardError; end

      def initialize(
        debug: false,
        command: COMMAND,
        socket_name: SOCKET_NAME,
        config_file_path: DEFAULT_CONFING_FILE_PATH
      )
        @debug = debug
        @tmux_cmd = command
        @socket_name = socket_name
        @config_file_path = config_file_path
      end

      def new_terminal(cmd, width: 80, height: 24, max_wait_time: 2, use_return_for_newline: false)
        cmd = "#{cmd}\n#{SLEEP_INFINITY}"

        session_name = "ttytest-#{SecureRandom.uuid}"
        tmux(*%W[-f #{@config_file_path} new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
        session = Session.new(self, session_name, use_return_for_newline)
        Terminal.new(session, max_wait_time, use_return_for_newline)
      end

      def new_default_sh_terminal
        new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 24, max_wait_time: 2, use_return_for_newline: false)
      end

      def new_sh_terminal(width: 80, height: 24, max_wait_time: 2, use_return_for_newline: false)
        new_terminal(%(PS1='$ ' /bin/sh), width: width, height: height, max_wait_time: max_wait_time,
                                          use_return_for_newline: use_return_for_newline)
      end

      # @api private
      def tmux(*args)
        ensure_available
        puts "tmux(#{args.inspect[1...-1]})" if debug?

        cmd = [@tmux_cmd, '-L', SOCKET_NAME, *args]
        output = nil
        status = nil
        IO.popen(cmd, err: %i[child out]) do |io|
          output = io.read
          io.close
          status = $CHILD_STATUS
        end

        raise TmuxError, "tmux(#{args.inspect[1...-1]}) failed\n#{output}" unless status&.success?

        output
      end

      def available?
        return false unless tmux_version

        @available ||= (Gem::Version.new(tmux_version) >= Gem::Version.new(REQUIRED_TMUX_VERSION))
      end

      private

      def debug?
        @debug
      end

      def ensure_available
        return if available?
        raise TmuxError, 'Running `tmux -V` to determine version failed. Is tmux installed?' unless tmux_version

        raise TmuxError, "tmux version #{tmux_version} does not meet requirement >= #{REQUIRED_TMUX_VERSION}"
      end

      def tmux_version
        @tmux_version ||= `#{@tmux_cmd} -V`[/tmux (\d+.\d+)/, 1]
      rescue Errno::ENOENT
        nil
      end
    end
  end
end
