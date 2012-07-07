class TestData < ActiveRecord::Migration
  def self.up
    org = Organisation.new(
      :title => "Dummy Organisation",
      :nickname => "dummy",
      :summary => "Plain old summary here."
    )
    org.sport_id = 1
    org.save

    season = Season.new(
      :title => '2006'
    )
    season.organisation_id = 1
    season.save

    user = User.new(:email => 'dummy@example.com',:password => 'password',:name => 'Dummy Admin')
    user.organisation_id = 1
    user.save
  end

  def self.down
    User.delete_all
    Season.delete_all
    Organisation.delete_all
  end
end
