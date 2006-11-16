module Test #:nodoc:
  module Unit #:nodoc:
    module Assertions
  
      def implement_me
        flunk('Test not yet implemented.')
      end
  
      # Explicit version of plain old assert.
      # Want to make sure got true and not something that resolves to the same.
      def assert_true(thing, message = nil)
        assert thing == true, message
      end
  
      # Explicit version of assert to test for false without using ugly ! stuff.
      # Want to make sure got false and not something that resolves to the same.
      def assert_false(thing, message = nil)
        assert thing == false, message
      end
  
      # Checks that an ActiveRecord model has a validation error on given field.
      def assert_error_on(field, model)
        assert !model.errors[field.to_sym].nil?, "No validation error on the #{field.to_s} field."
      end
  
      # Checks that an ActiveRecord model has no validation error on given field.
      def assert_no_error_on(field, model)
        assert model.errors[field.to_sym].nil?, "Validation error on #{field.to_s}."
      end
  
      # Check for difference in some method's result before and after block run.
      def assert_difference(objects, method = nil, difference = 1)
        objects = [objects].flatten
        initial_values = objects.inject([]) { |sum,obj| sum << obj.send(method) }
        yield
        if difference.nil?
          objects.each_with_index { |obj,i|
            assert_not_equal initial_values[i], obj.send(method), "#{obj}##{method}"
          }
        else
          objects.each_with_index { |obj,i|
            assert_equal initial_values[i] + difference, obj.send(method), "#{obj}##{method}"
          }
        end
      end
      
    end
  end
end