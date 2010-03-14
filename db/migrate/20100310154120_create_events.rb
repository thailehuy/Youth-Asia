class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :link
      t.string :eid
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
