module Tangle
  module Mixin
    # Tangle mixin for loading a directory structure as a graph
    #
    # Graph.new(directory: { options })
    #
    # options are:
    #   root:           root directory for the structure (mandatory)
    #   loaders:        list of object loader lambdas (mandatory)
    #   follow_links:   bool for following symlinks to directories
    #                   (default false)
    #
    # A loader lambda will be called like
    #   ->(graph, path, parent_path) { ... }
    #
    # The lambdas are called in order until one returns true
    #
    # Example:
    #   loader = lambda do |g, path, parent|
    #       vertex = File::Stat.new(path)
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
          @directory_loaders.any? do |loader|
            loader.to_proc.call(self, path, parent)
          end

          return if File.symlink?(path) && !@follow_directory_links
          return unless File.directory?(path)

          Dir.each_child(path) do |file|
            load_directory_graph(File.join(path, file), path)
          end
        end
      end
    end
  end
end
