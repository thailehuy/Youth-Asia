class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :eid
      t.string :f_type
      t.string :event_link

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
