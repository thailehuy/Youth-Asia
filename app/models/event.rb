class Event < ActiveRecord::Base
  CATEGORIES = [
    "Lifestyle", "Sport", "Music", "Fashion"
  ]

  validates_format_of :link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i
  validates_inclusion_of :category, :in => CATEGORIES
end
