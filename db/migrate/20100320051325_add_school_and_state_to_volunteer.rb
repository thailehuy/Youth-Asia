class AddSchoolAndStateToVolunteer < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :school, :string, :default => ""
    add_column :volunteers, :state, :string, :default => ""
  end

  def self.down
    remove_column :volunteers, :school
    remove_column :volunteers, :state
  end
end
