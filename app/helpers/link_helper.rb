module LinkHelper
  def menu_items
  [
    ["Home", {:controller => "youth", :action => "index"}],
    ["About", {:controller => "youth", :action => "about"}],
    ["Guide", {:controller => "youth", :action => "guide"}],
    ["Gatherings", {:controller => "youth", :action => "gathering"}],
    ["Volunteer", {:controller => "youth", :action => "volunteer"}],
    ["Book ticket", {:controller => "youth", :action => "booking"}],
    ["Giveaway", {:controller => "youth", :action => "giveaway"}]
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
        document.getElementById(div_id).setInnerHTML("#{loading_image}");
        var ajax = new Ajax();
        ajax.ondone = function(data)
        {
          document.getElementById(div_id).setInnerHTML(data);
        }

        var ajax_param = "?page=" + page;

        ajax.post(url + ajax_param);
      }
    }
  end

  def ajax_next_link(text, div_id, url)
    link_to_remote text, :url => url, :update => div_id,
      :before => "$('#{div_id}').innerHTML='#{loading_image}'"
  end

  def status_publisher
    fb_user = fbsession.users_getInfo(:uids => @uid,
            :fields => ["first_name"]).user_list.first
    %Q{
      callPublish('',{'name':'Youth 10','href':'http://apps.facebook.com/youthasia/','description':'#{fb_user.first_name} has just successfully secured a spot in Youth 2010 - Malaysia largest youth festival','media':[{'type':'image','src':'http://www.i-tich.net/facebook/mood/images/mood9.gif','href':'http://apps.facebook.com/youthasia/'}]},null);return false;
    }
  end
end