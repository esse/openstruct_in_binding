module V4
  class Binder
    def initialize(b)
      @binding = b
      @binding.local_variables.each do |name|
        get = ->() { @binding.local_variable_get(name) }
        set = ->(new_var) { @binding.local_variable_set(name, new_var) }
        define_singleton_method(name, get)
        define_singleton_method("#{name}=".to_sym, set)
      end
    end

    def method_missing(name, *args)
      if @binding.local_variables.include?(name)
        @binding.local_variable_get(name)
      elsif name.to_s[-1] == '='
        pure_name = name.to_s.delete('=').to_sym
        @binding.local_variable_set(pure_name, args[0])
        unless methods.include?(pure_name)
          set = ->(new_var) { @binding.local_variable_set(pure_name, new_var) }
          get = ->() { @binding.local_variable_get(pure_name) }
          define_singleton_method(name, set)
          define_singleton_method(pure_name, get)
        end
      else
        super
      end
    end
  end
end
