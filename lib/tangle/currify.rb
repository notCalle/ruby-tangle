# frozen_string_literal: true

module Tangle
  class CurrifyError < ArgumentError
    def initialize(msg = "method accepts no arguments", *)
      super
    end
  end

  # Currification of instance methods, for adding callbacks to other objects
  module Currify
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class method extensions for currification of instance methods
    module ClassMethods
      # Return a list of currified methods for a given tag.
      #
      # :call-seq:
      #   self.class.currified_methods(tag) => Array of Symbol
      def currified_methods(tag)
        mine = @currified_methods&.[](tag) || []
        return mine unless superclass.respond_to?(:currified_methods)

        superclass.currified_methods(tag) + mine
      end

      private

      # Add a symbol to the list of currified methods for a tag.
      #
      # :call-seq:
      #   class X
      #     currify :tag, :method
      def currify(tag, method)
        raise CurrifyError if instance_method(method).arity.zero?

        @currified_methods ||= {}
        @currified_methods[tag] ||= []
        @currified_methods[tag] << method
      end
    end

    private

    def define_currified_methods(obj, tag)
      self.class.currified_methods(tag)&.each do |name|
        obj.instance_exec(name, method(name).curry) do |method_name, method|
          define_singleton_method(method_name) do |*args|
            method.call(self, *args)
          end
        end
      end
    end
  end
end
