# frozen_string_literal: true

require 'open3'
require 'securerandom'

require 'ttytest/terminal'
require 'ttytest/tmux/session'

module TTYtest
  module Tmux
    class Driver
      COMMAND = 'tmux'
      SOCKET_NAME = 'ttytest'
      REQUIRED_TMUX_VERSION = '1.8'
      DEFAULT_CONFING_FILE_PATH = File.expand_path('../tmux.conf', __FILE__)
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

      def new_terminal(cmd, width: 80, height: 24)
        cmd = "#{cmd}\n#{SLEEP_INFINITY}"

        session_name = "ttytest-#{SecureRandom.uuid}"
        tmux(*%W[-f #{@config_file_path} new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
        session = Session.new(self, session_name)
        Terminal.new(session)
      end

      # @api private
      def tmux(*args)
        ensure_available
        puts "tmux(#{args.inspect[1...-1]})" if debug?

        cmd = [@tmux_cmd, '-L', SOCKET_NAME, *args]
        output = nil
        status = nil
        IO.popen(cmd, err: [:child, :out]) do |io|
          output = io.read
          io.close
          status = $?
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
        if !available?
          if !tmux_version
            raise TmuxError, "Running `tmux -V` to determine version failed. Is tmux installed?"
          else
            raise TmuxError, "tmux version #{tmux_version} does not meet requirement >= #{REQUIRED_TMUX_VERSION}"
          end
        end
      end

      def tmux_version
        @tmux_version ||= `#{@tmux_cmd} -V`[/tmux (\d+.\d+)/, 1]
      rescue Errno::ENOENT
        nil
      end
    end
  end
end
