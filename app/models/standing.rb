# This should be considered read only as it wraps an SQL view

class Standing < ActiveRecord::Base
  
  belongs_to :group
  belongs_to :team

  def totalplayed
    self.homeplayed + self.awayplayed
  end

  def totalwon
    self.homewon + self.awaywon
  end

  def totaldrawn
    self.homedrawn + self.awaydrawn
  end

  def totallost
    self.homelost + self.awaylost
  end

  def totalfor
    self.homefor + self.awayfor
  end

  def totalagainst
    self.homeagainst + self.awayagainst
  end

  def totaldifference
    self.totalfor - self.totalagainst
  end

end
