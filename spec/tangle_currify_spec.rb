# frozen_string_literal: true

RSpec.describe Tangle::Currify do
  it 'is a module' do
    expect(Tangle::Currify).to be_a Module
  end

  context 'when included in a class' do
    before :context do
      class TestClass
        include Tangle::Currify
      end
    end

    it 'can declare a method to be currified' do
      expect {
        class TestClass
          def currified_method; end
          currify :test, :currified_method
        end
      }.not_to raise_error
    end

    context 'and a method is currified' do
      before :context do
        class TestClass
          def initialize(object)
            define_currified_methods(object, :test)
          end

          def curry_arg(arg = nil)
            arg
          end
          currify :test, :curry_arg
        end
      end

      it 'knows that the method is currified' do
        expect(TestClass.currified_methods(:test)).to include(:curry_arg)
      end

      it 'can create curried methods in an object' do
        object = Object.new
        TestClass.new(object)
        expect(object.curry_arg).to eq object
      end

      it 'propagates currified methods to subclasses' do
        class TestSubClass < TestClass; end
        expect(TestSubClass.currified_methods(:test)).to include(:curry_arg)
      end
    end
  end
end
