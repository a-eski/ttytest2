# frozen_string_literal: true

require 'minitest/autorun'
require 'ttytest'

EMPTY = "\n" * 23
FOO_BAR_BAZ_THEN_EMPTY = "foo\nbar\nbaz#{"\n" * 21}".freeze
