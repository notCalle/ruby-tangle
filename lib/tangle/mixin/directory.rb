module Tangle
  module Mixin
    # Tangle mixin for loading a directory structure as a graph
    #
    # Graph.new(directory: { options })
    #
    # options are:
    #   root:           root directory for the structure (mandatory)
    #   loaders:        list of object loader lambdas (mandatory)
    #                     ->(graph, **) { ... } => finished?
    #   follow_links:   bool for following symlinks to directories
    #                   (default false)
    #
    # A loader lambda is called with the graph as only positional
    # argument, and a number of keyword arguments:
    #
    #   path:     Path of current filesystem object
    #   parent:   Path of filesystem parent object
    #   lstat:    File.lstat for path
    #   stat:     File.stat for path, if lstat.symlink?
    #
    # The lambdas are called in order until one returns true.
    #
    # Example:
    #   loader = lambda do |g, path:, parent:, lstat:, **|
    #       vertex = kwargs[:lstat]
    #       g.add_vertex(vertex, name: path)
    #       g.add_edge(g[parent], vertex) unless parent.nil?
    #     end
    #   Tangle::DiGraph.new(mixins: [Tangle::Mixins::Directory],
    #                       directory: { root: '.', loaders: [loader] })
    module Directory
      # Tangle::Graph mixin for loading a directory structure
      module Graph
        attr_reader :root_directory

        private

        def initialize_kwarg_directory(**options)
          @root_directory = options.fetch(:root)
          @directory_loaders = options.fetch(:loaders)
          @follow_directory_links = options[:follow_links]
          load_directory_graph(@root_directory)
        end

        def load_directory_graph(path, parent = nil)
          return unless load_directory_object(path, parent)

          Dir.each_child(path) do |file|
            load_directory_graph(File.join(path, file), path)
          end
        end

        # Load a filesystem object into the graph, returning
        # +true+ if the object was a directory (or link to one,
        # and we're following links).
        def load_directory_object(path, parent = nil)
          stat = lstat = File.lstat(path)
          stat = File.stat(path) if lstat.symlink?

          @directory_loaders.any? do |loader|
            loader.to_proc.call(self, path: path, parent: parent,
                                      lstat: lstat, stat: stat)
          end

          return if lstat.symlink? && !@follow_directory_links
          stat.directory?
        end
      end
    end
  end
end
