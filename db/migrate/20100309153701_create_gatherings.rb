class CreateGatherings < ActiveRecord::Migration
  def self.up
    create_table :gatherings do |t|
      t.string :name
      t.string :affiliation
      t.datetime :date_of_birth
      t.string :address
      t.string :email
      t.string :phone
      t.string :race
      t.string :ic_number
      t.string :event_link
      t.string :uid

      t.timestamps
    end
  end

  def self.down
    drop_table :gatherings
  end
end
