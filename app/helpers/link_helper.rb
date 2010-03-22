class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

  protected
  def page_link(page, text, attributes = {})
    @template.link_to_remote(text, {:url => url_for(page), :method => :get}.merge(@remote), attributes)
  end
end

module LinkHelper
  def menu_items
    [
      ["Home", {:controller => "youth", :action => "index"}],
      ["About", {:controller => "youth", :action => "about"}],
      ["Festival Guide", {:controller => "youth", :action => "guide"}],
      ["Youth Gatherings", {:controller => "youth", :action => "gathering"}],
      ["Volunteer", {:controller => "youth", :action => "volunteer"}],
      ["Book ticket", {:controller => "youth", :action => "booking"}],
      ["Invite Friends", {:controller => "youth", :action => "giveaway"}]
    ]
  end

  def event_link(event)
    "http://www.facebook.com/event.php?eid=#{event.eid}"
  end

  def navigation_menu current_tab = ""
    links = menu_items.map{|m|
      %Q{
        <li class="#{current_tab == m[0] ? "active" : ""}">
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
          'type':'image','src':'#{SERVER_URL + "/images/feed_icon.jpg"}',
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
    event = fbsession.events_get(:eids => [gathering.eid]).event_list.first
    js = <<-JS
      callPublish('', {
        'name' : 'Youth 10',
        'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}',
        'description' : '#{fb_user.first_name} has just submitted a gathering in Youth 2010 - Malaysia largest youth festival',
        'media' : [ {
            'type' : 'image',
            'src' : '#{event.pic}',
            'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}'
          }
        ]
      }, [ {
          'text' : 'Join #{fb_user.first_name}\\\'s gathering',
          'href' : '#{gathering.event_link}'
        }
      ]);
    JS
  end

  def joining_publisher(event)
#    fb_user = fbsession.users_getInfo(:uids => @uid, :fields => ["first_name"]).user_list.first
    event = fbsession.events_get(:eids => [event.eid]).event_list.first
    js = <<-JS
      callPublish('', {
        'name' : 'Youth 10',
        'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}',
        'description' : 'I\\\'m coming to #{event.name.gsub("'", "\\\\\\'")} at Youth \\\'10 - Malaysia\\\'s largest youth festival. Join me!',
        'media' : [ {
            'type' : 'image',
            'src' : '#{event.pic}',
            'href' : 'http://apps.facebook.com/youthasia/youth/landing?from_ref=#{@uid}'
          }
        ]
      }, [ {
          'text' : 'Join event',
          'href' : '#{event_link(event)}'
        }
      ]);
    JS
  end
end