class Feature < ActiveRecord::Base
  TYPES = ["gathering", "event", "story"]

  validates_format_of :event_link, :with => /^http:\/\/(www.)?facebook.com\/event.php\?eid=\d+(&|$)/i,
    :if => Proc.new{|f| f.f_type != "story" }
end
