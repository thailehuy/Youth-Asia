# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_time time_stamp
    Time.at(time_stamp.to_i).strftime("%b %d, %H:%M")
  end

  def display_attendant(event)
#    fbsession.events_getMembers(:eid => event.eid).attending.scan(/<uid>(.+)<\/uid>/).size
    fbsession.events_getMembers(:eid => event.eid).attending.gsub(" ", "").split("\n").compact.delete_if{|e| e.blank?}.size
  end
end
