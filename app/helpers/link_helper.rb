module LinkHelper
  def menu_items
  [
    ["Home", {:controller => "youth", :action => "index"}],
    ["About", {:controller => "youth", :action => "about"}],
    ["Festival Guide", {:controller => "youth", :action => "guide"}],
    ["Youth Gatherings", {:controller => "youth", :action => "gathering"}],
    ["Volunteer", {:controller => "youth", :action => "volunteer"}],
    ["Book ticket", {:controller => "youth", :action => "booking"}],
    ["RM50,000 Giveaway", {:controller => "youth", :action => "giveaway"}]
  ]
  end

  def event_link(event)
    "http://www.facebook.com/event.php?eid=#{event.eid}"
  end

  def navigation_menu current_tab = ""
    links = menu_items.map{|m|
      %Q{
        <li class="#{current_tab == m[0] ? "current" : ""}">
          #{link_to(m[0], m[1], :class => "navlink") }
        </li>
      }
    }

    return "<ul>#{links.join}</ul>"
  end

  def book_ticket_url
    "/youth/booking"
  end

  def download_guide_url
    "dummy for now"
  end

  def loading_image
    image_tag("/images/loading.gif", :alt => "Loading ...")
  end

  def ajax_paging_js
    %Q{
      function show_more(div_id, url, page)
      {
        document.getElementById(div_id).setInnerFBML("#{loading_image}");
        var ajax = new Ajax();
        ajax.responseType = Ajax.FBML;
        ajax.ondone = function(data)
        {
          document.getElementById(div_id).setInnerFBML(data);
        }

        var ajax_param = "?page=" + page;

        ajax.post(url + ajax_param);
      }
    }
  end

  def ajax_next_link(text, div_id, url, page)
    link_to_function text, :onclick => "show_more('#{div_id}', '#{url}', '#{page}')"
  end
end