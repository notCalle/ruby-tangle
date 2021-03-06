# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter %r{^/spec/}
end
if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'tangle'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module Helpers
  module TestMixin
    module Graph
      def mixin_ok?
        @mixin_ok
      end

      private

      def initialize_kwarg_mixin_ok(value)
        @mixin_ok = value
      end
    end

    module Edge
      def mixin_ok?
        true
      end
    end
  end
end
