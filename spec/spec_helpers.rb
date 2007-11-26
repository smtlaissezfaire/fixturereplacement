module SpecHelperFunctions
  # We need this just so that the tests don't fail
  # when we are running the tests outside of a real rails project.
  # Otherwise, the tests would fail with a file not found error,
  # since db/example_data.rb is no where to be found
  def swap_out_require!
    Kernel.module_eval do
      alias_method :__old_require, :require

      def require(string)
        unless string == "/db/example_data.rb"
          __old_require(string)
        end
      end
    end
  end  
end
