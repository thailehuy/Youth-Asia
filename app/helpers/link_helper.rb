module LinkHelper
  def menu_items
  [
    ["Home", "/"],
    ["About", url_for(:controller => "youth", :action => "about")],
    ["Festival Guide", url_for(:controller => "youth", :action => "guide")],
    ["Youth Gatherings", url_for(:controller => "youth", :action => "gathering")],
    ["Volunteer", url_for(:controller => "youth", :action => "volunteer")],
    ["Book ticket", url_for(:controller => "youth", :action => "booking")],
    ["RM50,000 Giveaway", url_for(:controller => "youth", :action => "giveaway")]
  ]
  end

  def event_link(event)
    "http://www.facebook.com/event.php?eid=#{event.eid}"
  end

  def navigation_menu current_tab = ""
    links = menu_items.map{|m|
      %Q{
        <li class="#{current_tab == m[0] ? "current" : ""}">
          #{link_to(m[0], m[1], :class => "navlink")}
        </li>
      }
    }

    return "<ul>#{links.join}</ul>"
  end

  def book_ticket_url
    url_for(:controller => "youth", :action => "booking")
  end

  def download_guide_url
    "dummy for now"
  end
end