module LinkHelper
  MENU_ITEMS = [
    ["Text", "link"]
  ]

  def event_link(event)
    "http://www.facebook.com/event.php?eid=#{event.eid}"
  end

  def navigation_menu current_tab = ""
    links = MENU_ITEMS.map{|m|
      %Q{
        <li class="#{current_tab == m[0] ? "current" : ""}">
          #{link_to(m[0], m[1], :class => "navlink")}
        </li>
      }
    }

    return "<ul>#{links.join}</ul>"
  end

  def book_ticket_url
    "dummy for now"
  end

  def download_guide_url
    "dummy for now"
  end
end