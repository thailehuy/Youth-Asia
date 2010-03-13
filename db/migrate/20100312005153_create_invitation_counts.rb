class CreateInvitationCounts < ActiveRecord::Migration
  def self.up
    create_table :invitation_counts do |t|
      t.string :uid
      t.integer :counter, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :invitation_counts
  end
end
