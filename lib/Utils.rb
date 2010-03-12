module Utils
  def Utils.get_event_eid
    link = params[:feature][:event_link].split("?").last
    uri = CGI::parse(link)
    uri["eid"].first
  end
end