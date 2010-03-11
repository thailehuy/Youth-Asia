# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_time time_stamp
    Time.at(time_stamp.to_i).strftime("%a %b %d, %H:%M")
  end
end
