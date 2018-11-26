# frozen_string_literal: true

module Tangle
  begin
    require 'git-version-bump'
    VERSION = GVB.version.freeze
  rescue LoadError
    VERSION = '0.0.0.UNDEF'
  end
end
