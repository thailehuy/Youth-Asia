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
      t.string :position_1
      t.string :position_2
      t.string :position_3
      t.text :reason
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteers
  end
end
