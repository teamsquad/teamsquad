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
  end

  def self.down
		Organisation.delete_all
		Season.delete_all
  end
end
