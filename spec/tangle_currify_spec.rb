# frozen_string_literal: true

RSpec.describe Tangle::Currify do
  it 'is a module' do
    expect(Tangle::Currify).to be_a Module
  end

  context 'when included in a class' do
    before :context do
      @test_class = Class.new do
        include Tangle::Currify
      end
    end

    it 'can declare a method to be currified' do
      expect {
        Class.new @test_class do
          def currified_method(arg); end
          currify :test, :currified_method
        end
      }.not_to raise_error
    end

    it 'requires a currified method to have at least one argument' do
      expect {
        Class.new @test_class do
          def currified_noarg; end
          currify :test, :currified_noarg
        end
      }.to raise_error Tangle::CurrifyError
    end

    context 'and a method is currified' do
      before :context do
        @test_class = Class.new do
          include Tangle::Currify

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
        expect(@test_class.currified_methods(:test)).to include(:curry_arg)
      end

      it 'can create curried methods in an object' do
        object = Object.new
        @test_class.new(object)
        expect(object.curry_arg).to eq object
      end

      it 'propagates currified methods to subclasses' do
        expect(Class.new(@test_class).currified_methods(:test)).to include(:curry_arg)
      end
    end
  end
end
