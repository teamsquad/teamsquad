class CreateInviteCodes < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.column :code, :string, :length => 16, :null => false, :unique => true
      t.column :recipient, :string
      t.column :used, :boolean, :default => false
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
    
    20.times do 
      temp_code = rand(99999999999) + 1000000000000
      Invite.create(:code => temp_code.to_s)
    end
  end

  def self.down
    drop_table :invites
  end
end
