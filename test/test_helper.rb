ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def implement_me
    flunk('Test not yet implemented.')
  end

  # Explicit version of plain old assert.
  # Want to make sure got true and not something that resolves to the same.
  def assert_true(thing, message = '')
    assert thing == true, message
  end

  # Explicit version of assert to test for false without using ugly ! stuff.
  # Want to make sure got false and not something that resolves to the same.
  def assert_false(thing, message = '')
    assert thing == false, message
  end

  # Checks that an ActiveRecord model has a validation error on given field.
  def assert_error_on(field, model)
    assert !model.errors[field.to_sym].empty?, "No validation error on the #{field.to_s} field. #{model.errors.inspect}"
  end

  # Checks that an ActiveRecord model has no validation error on given field.
  def assert_no_error_on(field, model)
    assert model.errors[field.to_sym].empty?, "Validation error on #{field.to_s}. #{model.errors.get(field.to_sym)}"
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
