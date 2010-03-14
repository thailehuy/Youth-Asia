module Utils
  def Utils.get_event_eid event_link
    link = event_link.split("?").last
    uri = CGI::parse(link)
    uri["eid"].first
  end
end