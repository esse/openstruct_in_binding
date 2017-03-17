require 'benchmark'
require 'benchmark/ips'
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
  Benchmark.ips do |x|
    x.report("#{namespace} binder") { namespace::Binder.new(b) }
    x.report("OpenStruct")  { OpenStruct.new(hash) }
    x.compare!
  end

  binder = namespace::Binder.new(b)
  struct = OpenStruct.new(hash)

  puts 'get'
  Benchmark.ips do |x|
    x.report("#{namespace} binder") { binder.a; binder.str }
    x.report("OpenStruct") { struct.a; struct.str }
    x.compare!
  end


  binder = namespace::Binder.new(b)
  struct = OpenStruct.new(hash)

  puts 'set'
  Benchmark.ips do |x|
    x.report("#{namespace} binder") { binder.a = 2; binder.string_2 = 'abc' }
    x.report("OpenStruct") { struct.a = 2; struct.string_2 = 'abc' }
    x.compare!
  end


  binder = namespace::Binder.new(b)
  struct = OpenStruct.new(hash)

  puts 'set different'
  Benchmark.ips do |x|
    x.report("#{namespace} binder") { binder.send("var_#{n}=".to_sym, 1) }
    x.report("OpenStruct") { struct.send("var_#{n}=".to_sym, 1) }
    x.compare!
  end

  print "\n\n\n"
end

benchmark(V1)
benchmark(V2)
benchmark(V3)
benchmark(V4)
