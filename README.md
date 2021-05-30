[![Gem Version](https://badge.fury.io/rb/tangle.svg)](https://badge.fury.io/rb/tangle)
[![Maintainability](https://api.codeclimate.com/v1/badges/0d92a4d05b6bb5c06dce/maintainability)](https://codeclimate.com/github/notCalle/ruby-tangle/maintainability)
[![codecov](https://codecov.io/gh/notCalle/ruby-tangle/branch/master/graph/badge.svg)](https://codecov.io/gh/notCalle/ruby-tangle)
[![Ruby](https://github.com/notCalle/ruby-tangle/actions/workflows/ruby.yml/badge.svg)](https://github.com/notCalle/ruby-tangle/actions/workflows/ruby.yml)

# Tangle

Tangle aims to untangle your graphs, by providing a set of classes for managing different types of graphs, and mixins for adding specific feature sets.

**Graph types**:
 * SimpleGraph
 * MultiGraph
 * DiGraph
 * DAG
 * ~~Tree~~

**Feature mixins**:
 * Filesystem directory graph
 * ~~Coloring~~
 * ~~GraphViz~~

See the [changelog](CHANGELOG.md) for recent changes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tangle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tangle

## Usage

```ruby
g=Tangle::SimpleGraph.new
g.add_vertex name: 'a'
g.add_vertex name: 'b'
g.add_edge 'a', 'b'
g.connected?
=> true
g.add_edge 'b', 'b'
=> Tangle::LoopError (loops not allowed)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Mixin API

A mixin is a module with optional submodules for each of the classes
`Graph`, `Vertex`, and `Edge`. If the mixin needs initial state it
should provide a keyword initializer `#initialize_kwarg_KEYWORD(argument)`,
that will be called when the object is `#initalize`d with a matching kwarg.

Example:
```ruby
module WeightedEdges
	module Edge
		def initialize_kwarg_weight(weight)
			@weight = weight
		end

		def weight
			@weight
		end

		def weight=(new_weight)
			@weight = new_weight
		end
	end
end

Tangle::Graph.new(mixins: [WeightedEdges])
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/notCalle/tangle. Pull requests should be rebased to HEAD of `master` before submitting, and all commits must be signed with valid GPG key. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tangle project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/notCalle/tangle/blob/master/CODE_OF_CONDUCT.md).
