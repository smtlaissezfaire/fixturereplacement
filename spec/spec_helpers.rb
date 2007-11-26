module SpecHelperFunctions
  # We need this just so that the tests don't fail
  # when we are running the tests outside of a real rails project.
  # Otherwise, the tests would fail with a file not found error,
  # since db/example_data.rb is no where to be found
  def swap_out_require!
    Kernel.module_eval do
      
      # Thanks, Jay Fields:
      # http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
      require_method = instance_method(:require)

      define_method(:require) do |string|
        unless string == "/db/example_data.rb"
          require_method.bind(self).call(string)
        end
      end
    end
  end  
end
