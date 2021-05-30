# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- The required Ruby version is now 3.0.

- Mixin initializers that relied on Ruby 2 kwarg splat semantics for Hash argument
  must be changed to accept a single positional argument.

- Dependencies have been updated.


## [0.10.2] - 2019-07-05

### Changed

- `Currify::currify`now raises a `CurrifyError` < `ArgumentError` when the
  method takes no arguments, instead of the curried method failing when called

- Development dependency on `bundler` is updated to `~> 2.0`.

### Fixed

- `Graph#connected_subgraph` and `Graph#disconnected_subgraph` called an invalid
  method to determine connectedness of candidate vertices


## [Older]
These releases have no change logs.


[Unreleased]: https://github.com/notCalle/ruby-tangle/compare/v0.3.0..HEAD
[0.10.2]: https://github.com/notCalle/ruby-tangle/compare/v0.10.1..v0.10.2
[Older]: https://github.com/notCalle/ruby-tangle/releases/tag/v0.10.1
