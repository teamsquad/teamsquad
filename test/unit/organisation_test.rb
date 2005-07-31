require File.dirname(__FILE__) + '/../test_helper'

class OrganisationTest < Test::Unit::TestCase
  fixtures :sports, :organisations, :teams, :seasons, :competitions, :stages, :groups

  def setup
    @organisation = Organisation.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Organisation,  @organisation
  end
end
