# frozen_string_literal: true

require 'git-version-bump'

module Tangle
  VERSION = GVB.version.freeze
  DATE = GVB.date.freeze
end
