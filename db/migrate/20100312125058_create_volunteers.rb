class CreateVolunteers < ActiveRecord::Migration
  def self.up
    create_table :volunteers do |t|
      t.string :uid
      t.string :name
      t.string :affiliation
      t.string :email
      t.string :phone
      t.string :date_of_birth
      t.string :address
      t.string :race
      t.string :ic_number
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteers
  end
end
