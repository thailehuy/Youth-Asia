class AddEidToGathering < ActiveRecord::Migration
  def self.up
    add_column :gatherings, :eid, :string

    Gathering.all.each do |gathering|
      gathering.update_eid
    end
  end

  def self.down
    remove_column :gatherings, :eid
  end
end
