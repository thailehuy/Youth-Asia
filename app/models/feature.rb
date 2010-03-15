class Feature < ActiveRecord::Base
  validates_format_of :event_link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i
end
