class EssentialData < ActiveRecord::Migration
  def self.up
    Sport.create :title => "Football"
    Sport.create :title => "Cricket", :uses_scores => false, :uses_manual_points => true
    Sport.create :title => "Hockey", :uses_scores => true
    Sport.create :title => "Rugby", :uses_scores => true, :uses_manual_points => true
    Sport.create :title => "Chess", :uses_scores => true
    Sport.create :title => "Generic score based sport", :uses_scores => true
    Sport.create :title => "Generic points based sport", :uses_scores => false, :uses_manual_points => true
  end

  def self.down
    Sport.delete_all
  end
end
