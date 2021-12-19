# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Updated `bundler` development dependency for CVE-2021-43809


## [0.11.0] - 2021-05-30

This release updates dependencies, changes the minimum Ruby version to 2.6, and adds support for Ruby version 3.

### Added

- Ruby version 3 is now supported, and mixin initializers should not rely on keyword splat semantics for a `Hash` argument.

### Changed

- The minimum required Ruby version is now 2.6.

- Dependencies have been updated.


## [0.10.2] - 2019-07-05

### Changed

- `Currify::currify`now raises a `CurrifyError` < `ArgumentError` when the method takes no arguments, instead of the curried method failing when called

- Development dependency on `bundler` is updated to `~> 2.0`.

### Fixed

- `Graph#connected_subgraph` and `Graph#disconnected_subgraph` called an invalid method to determine connectedness of candidate vertices


## [Older]
These releases have no change logs.


[Unreleased]: https://github.com/notCalle/ruby-tangle/compare/v0.11.0..HEAD
[0.11.0]: https://github.com/notCalle/ruby-tangle/compare/v0.10.2..v0.11.0
[0.10.2]: https://github.com/notCalle/ruby-tangle/compare/v0.10.1..v0.10.2
[Older]: https://github.com/notCalle/ruby-tangle/releases/tag/v0.10.1
