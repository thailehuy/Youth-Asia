module LinkHelper
  MENU_ITEMS = [
    ["Text", "link"]
  ]

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
end