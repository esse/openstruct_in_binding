module V2
  class Binder
    def initialize(b)
      @binding = b
      @binding.local_variables.each do |var|
        l = -> { @binding.local_variable_get(var) }
        define_singleton_method(var, l)
      end
    end

    def method_missing(name, *args)
      if @binding.local_variables.include?(name)
        @binding.local_variable_get(name)
      elsif name.to_s[-1] == '='
        @binding.local_variable_set(name.to_s.delete('=').to_sym, args[0])
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      if method_name[-1] == '='
        true
      else
        @binding.local_variables.include?(method_name) || super
      end
    end
  end
end
