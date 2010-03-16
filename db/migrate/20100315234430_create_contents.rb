class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.text :volunteer_opp
      t.string :video_link
      t.text :about_youthsay
      t.text :about_youth10

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
