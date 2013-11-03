class Modification < ActiveRecord::Base

  attr_accessible :value
  
  validates_presence_of :value, :notes, :group_id, :team_id
  
  validates_each :value do |mod, attr, value|
    if value.to_i == 0
      mod.errors.add attr, "Must be a postive or negative number."
    end
  end
end
