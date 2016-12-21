require 'minitest/autorun'
require_relative 'get_binding'
require_relative 'binder_ruby_v1'
require_relative 'binder_ruby_v2'
require_relative 'binder_ruby_v3'
require_relative 'binder_ruby_v4'
[V1, V2, V3, V4].each do |version|
  describe version::Binder do

    before(:each) do
      b = GetBinding.get_binding
      @binder = version::Binder.new(b)
    end

    describe "#{version}::Binder" do
      it 'can read val' do
        @binder.a.must_equal(10)
        @binder.str.must_equal('a1b2')
        @binder.must_respond_to(:a)
        @binder.must_respond_to(:str)
        @binder.wont_respond_to(:bad_val)
        @binder.must_respond_to(:"bad_val=")
      end

      it 'can set val' do
        @binder.a = 10 # test for exception
        @binder.new_val = 10 # test for exception
      end

      it 'can read setted val' do
        @binder.a = 'new_val'
        @binder.new_val = 10
        @binder.a.must_equal('new_val')
        @binder.new_val.must_equal(10)
      end

    end
  end
end
