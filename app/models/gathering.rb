class Gathering < ActiveRecord::Base
  attr_accessor :agreement

  validates_acceptance_of :agreement, :allow_nil => false, :accept => "on"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :event_link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i
  validates_presence_of :eid, :message => "Please provide a valid event"
end
