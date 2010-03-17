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

  def loading_image(width = 100, height = 50)
    image_tag("/images/loading.gif", :alt => "Loading ...", :width => width, :height => height)
  end

  def ajax_next_link(text, div_id, url)
    link_to_remote text, :url => url, :update => div_id,
      :before => "$('#{div_id}').innerHTML='#{loading_image("100%", "150")}'"
  end

  def status_publisher
    fb_user = fbsession.users_getInfo(:uids => @uid,
            :fields => ["first_name"]).user_list.first
    %Q{
      callPublish('',
        {'name':'Youth 10','href':'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}',
        'description':'#{fb_user.first_name} has just successfully secured a spot in Youth 2010 - Malaysia largest youth festival',
        'media':
          [
            {
            'type':'image','src':'http://www.i-tich.net/facebook/mood/images/mood9.gif',
            'href':'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}'
            }
          ]
        },
        [{ 'text': 'Book ticket', 'href': 'http://apps.facebook.com/youthasia/youth/booking'}]);
        return false;
    }
  end

  def gathering_publisher(gathering)
    fb_user = fbsession.users_getInfo(:uids => @uid, :fields => ["first_name"]).user_list.first
    js = <<-JS
      callPublish('', {
        'name' : 'Youth 10',
        'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}',
        'description' : '#{fb_user.first_name} has just submitted a gathering in Youth 2010 - Malaysia largest youth festival',
        'media' : [ {
            'type' : 'image',
            'src' : 'http://www.i-tich.net/facebook/mood/images/mood9.gif',
            'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}'
          }
        ]
      }, [ {
          'text' : 'Join #{fb_user.first_name}\'s gathering',
          'href' : '#{gathering.event_link}'
        }
      ]);
    JS
  end
end