class EssentialData < ActiveRecord::Migration
  def self.up
		Sport.create :title => "Football"
		Sport.create :title => "Cricket", :uses_scores => false, :uses_manual_points => true
  end

  def self.down
		Sport.delete_all
  end
end
