class Volunteer < ActiveRecord::Base
  POSITION = [
    "Position 1",
    "Position 2",
    "Position 3",
  ]

  SCHOOLS = [
    "Jr High", "Sr High"
  ]

  STATES = [
    "State 1", "State 2"
  ]

  has_attachment :max_size => 500.kilobytes

  validates_as_attachment

  validates_inclusion_of :school, :in => SCHOOLS
  validates_inclusion_of :state, :in => STATES

  validates_presence_of :name, :message => "Please enter your name"
  validates_presence_of :email, :message => "Please enter your email"
  validates_presence_of :ic_number, :message => "Please enter your IC number"
  validates_presence_of :position_1, :message => "Please choose your first preferred position"
  validates_presence_of :reason, :message => "Please tell us why you want to volunteer"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
end
