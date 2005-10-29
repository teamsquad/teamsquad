class TestData < ActiveRecord::Migration
  def self.up
		Organisation.create(
			:title => "Dummy Organisation",
			:sport_id => 1,
			:nickname => "dummy",
			:summary => "Plain old summary here."
		)
		
		Season.create(
			:title => '2005',
			:organisation_id => 1
		)
		
		User.create (
		  :organisation_id => 1,
		  :email => 'dummy@example.com',
		  :password => 'this is insecure for now',
		  :name => 'Dummy Admin'
		)
  end

  def self.down
    User.delete_all
    Season.delete_all
		Organisation.delete_all
  end
end
