require 'minitest/autorun'
require_relative 'get_binding'
require_relative 'binder_ruby_v1'
require_relative 'binder_ruby_v2'
require_relative 'binder_ruby_v3'
require_relative 'binder_ruby_v4'

class TestBindings < Minitest::Test
  def setup
    @binding = GetBinding.get_binding
  end
  [V1, V2, V3, V4].each do |version|
    define_method "test_#{version}_binder_can_read_val".to_sym do
      binder = version::Binder.new(@binding)
      assert_equal binder.a, 10
      assert_equal binder.str, 'a1b2'
      assert binder.respond_to?(:a)
      assert binder.respond_to?(:str)
      assert !binder.respond_to?(:bad_val)
      assert binder.respond_to?(:"bad_val=")
    end

    define_method "test_#{version}_binder_can_set_val".to_sym do
      binder = version::Binder.new(@binding)
      binder.a = 10 # test for exception
      binder.new_val = 10 # test for exception
    end

    define_method "test_#{version}_binder_can_read_setted_val".to_sym do
      binder = version::Binder.new(@binding)
      binder.a = 'new_val'
      binder.new_val = 10
      assert_equal binder.a, 'new_val'
      assert_equal binder.new_val, 10
    end
  end
end