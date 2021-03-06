# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_time time_stamp
    Time.at(time_stamp.to_i).strftime("%b %d, %H:%M")
  end

  def display_attendant(event)
#    fbsession.events_getMembers(:eid => event.eid).attending.scan(/<uid>(.+)<\/uid>/).size
    fbsession.events_getMembers(:eid => event.eid).attending.uid_list.size
  end

  def escape_string(s)
    s.gsub(/['"\\]/) do |c|
      "\\#{c}"
    end
  end
end
