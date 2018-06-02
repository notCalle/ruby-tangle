# frozen_string_literal: true

RSpec.describe Tangle::Mixin do
  it 'is a module' do
    expect(Tangle::Mixin).to be_a Module
  end

  context 'a mixin' do
    before :context do
      @mixins = [Helpers::TestMixin]
    end

    it 'can provide methods' do
      expect(Tangle::Graph.new(mixins: @mixins)).to respond_to :mixin_ok?
    end

    it 'can provide keyword initializers' do
      expect {
        Tangle::Graph.new(mixins: @mixins, mixin_ok: true)
      }.not_to raise_error

      expect {
        Tangle::Graph.new(mixins: @mixins, mixin_broken: true)
      }.to raise_error NoMethodError
    end
  end
end
