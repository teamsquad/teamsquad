class CreateContactResponses < ActiveRecord::Migration
  def self.up
    create_table :contact_responses do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :message, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :resolved, :boolean, :default => false
    end
  end

  def self.down
    drop_table :contact_responses
  end
end
