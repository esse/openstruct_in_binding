require 'benchmark'
require 'ostruct'
require_relative 'binder_ruby_v1'
require_relative 'binder_ruby_v2'
require_relative 'binder_ruby_v3'
require_relative 'binder_ruby_v4'
require_relative 'get_binding'

def benchmark(namespace)
  puts "Version #{namespace}"
  b = GetBinding.get_binding
  hash = { a: 10, str: 'a1b2' }

  puts 'creation'
  n = 500_000
  Benchmark.bm do |x|
    x.report { n.times { namespace::Binder.new(b) } }
    x.report { n.times { OpenStruct.new(hash) } }
  end


  binder = namespace::Binder.new(b)
  struct = OpenStruct.new(hash)

  puts 'get'
  Benchmark.bm do |x|
    x.report { n.times { binder.a; binder.str } }
    x.report { n.times { struct.a; struct.str } }
  end

  puts 'set'
  Benchmark.bm do |x|
    x.report { n.times { binder.a = 2; binder.string_2 = 'abc' } }
    x.report { n.times { struct.a = 2; struct.string_2 = 'abc' } }
  end

  puts 'set different'
  Benchmark.bm do |x|
    x.report { n.times { binder.send("var_#{n}=".to_sym, 1) } }
    x.report { n.times { struct.send("var_#{n}=".to_sym, 1) } }
  end

  print "\n\n\n"
end

benchmark(V1)
benchmark(V2)
benchmark(V3)
benchmark(V4)
