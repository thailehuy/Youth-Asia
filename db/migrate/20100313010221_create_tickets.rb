class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :uid
      t.string :name
      t.string :email
      t.string :phone
      t.string :ic_number

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
