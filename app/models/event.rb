class Event < ActiveRecord::Base
  CATEGORIES = [
    "Sports Festival",
    "Dance Festival",
    "Discovery Festival",
    "Music Festival",
    "Youth Brand Festival",
    "Shopping Festival",
    "Conferences"
  ]

  validates_format_of :link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i
  validates_inclusion_of :category, :in => CATEGORIES
end
