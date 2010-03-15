class Gathering < ActiveRecord::Base
  attr_reader :agreement

  validates_acceptance_of :agreement, :allow_nil => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :event_link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i
end
