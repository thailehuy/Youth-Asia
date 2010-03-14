class Volunteer < ActiveRecord::Base
  POSITION = [
    "Position 1",
    "Position 2",
    "Position 3",
  ]
  has_attachment :storage => :file_system,
                 :max_size => 500.kilobytes

  validates_as_attachment

#  t.string :uid
#      t.string :name
#      t.string :affiliation
#      t.string :email
#      t.string :phone
#      t.string :date_of_birth
#      t.string :address
#      t.string :race
#      t.string :ic_number
#      t.string :position_1
#      t.string :position_2
#      t.string :position_3
#      t.text :reason

  validates_presence_of :name, :message => "Please enter your name"
  validates_presence_of :email, :message => "Please enter your email"
  validates_presence_of :address, :message => "Please enter your address"
  validates_presence_of :ic_number, :message => "Please enter your IC number"
  validates_presence_of :position_1, :message => "Please choose your first preferred position"
  validates_presence_of :reason, :message => "Please tell us why you want to v"
end
