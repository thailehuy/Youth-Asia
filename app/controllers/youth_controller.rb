class YouthController < ApplicationController
  PER_PAGE = 4

  def landing
    InvitationCount.find_or_create_by_uid_and_invited_uid(params[:from_ref], @uid) unless @uid.to_s == params[:from_ref].to_s
    redirect_to :action => "index"
  end

  def index
    @current_tab = "Home"
    @page = 1
    @featured_events = []
    @featured_gatherings = []
    uids = fbsession.friends_get.friend_list
    @friend_uids = uids[0...PER_PAGE]
    @have_next_friend_page = uids.size > @friend_uids.size

    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list

    featured_event_eids = Feature.find(:all,
      :conditions => {:f_type => "event"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    @have_next_event_page = Feature.count(:conditions => {:f_type => "event"}) > featured_event_eids.size
    unless featured_event_eids.empty?
      @featured_events = fbsession.events_get(:eids => featured_event_eids).event_list
    end

    featured_gathering_eids = Feature.find(:all,
      :conditions => {:f_type => "gathering"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    @have_next_gathering_page = Feature.count(:conditions => {:f_type => "gathering"}) > featured_gathering_eids.size
    unless featured_gathering_eids.empty?
      @featured_gatherings = fbsession.events_get(:eids => featured_gathering_eids).event_list
    end

    @ticket_rsvp = Ticket.find_by_uid(@uid)
  end

  def show_friend_page
    @page = params[:page] || 1
    @page = @page.to_i
    p_start = (@page - 1) * PER_PAGE
    p_end = @page * PER_PAGE
    uids = fbsession.friends_get.friend_list
    @friend_uids = uids[p_start...p_end]
    @have_next_friend_page = uids.size > @friend_uids.size
    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
    render :partial => "youth/friend_panel"
  end

  def show_event_page
    @featured_events = []
    @page = params[:page] || 1
    @page = @page.to_i
    p_start = (@page - 1) * PER_PAGE
    
    featured_event_eids = Feature.find(:all,
      :conditions => {:f_type => "event"}, :limit => PER_PAGE, :offset => p_start).map{|e| e.eid.to_s}
    @have_next_event_page = Feature.count(:conditions => {:f_type => "event"}) > featured_event_eids.size
    unless featured_event_eids.empty?
      @featured_events = fbsession.events_get(:eids => featured_event_eids).event_list
    end
    render :partial => "youth/event_panel"
  end

  def show_gathering_page
    @featured_gatherings = []
    @page = params[:page] || 1
    @page = @page.to_i
    p_start = (@page - 1) * PER_PAGE

    featured_gathering_eids = Feature.find(:all,
      :conditions => {:f_type => "gathering"}, :limit => PER_PAGE, :offset => p_start).map{|e| e.eid.to_s}
    @have_next_gathering_page = Feature.count(:conditions => {:f_type => "gathering"}) > featured_gathering_eids.size
    unless featured_gathering_eids.empty?
      @featured_gatherings = fbsession.events_get(:eids => featured_gathering_eids).event_list
    end
    render :partial => "youth/gathering_panel"
  end

  def about
    @current_tab = "About"
  end
  #filter
  def guide
    @current_tab = "Guide"
    events = Event.find(:all)

    (1..4).to_a.each do |index|
      if params["cat#{index}".to_sym].to_i == 0
        events.delete_if{|e| e.category == Event::CATEGORIES[index]}
      end
    end

    start_date_offset = 0
    end_date_offset = 0

    (1..3).to_a.each do |index|
      if params["date#{index}".to_sym].to_i == 1
        start_date_offset += (index - 1) unless start_date_offset > 0
        end_date_offset += (index - 1)
      end
    end

    start_date = (DateTime.parse("May 28") + start_date_offset.days).to_time.to_i
    end_date = (DateTime.parse("May 28") + end_date_offset.days).to_time.to_i
    @events = []
    unless events.blank?
      @events = fbsession.events_get(:eids => events.collect{|e| e.eid},
                :start_time => start_date, :end_time => end_date).event_list
    end
    @first_event = @events.first
    @event_slice_1 = @events.select{|e|
      Time.at(e.start_time.to_i) < DateTime.parse("May 29").to_time
    }
    @event_slice_2 = @events.select{|e|
      Time.at(e.start_time.to_i) < DateTime.parse("May 30").to_time && Time.at(e.start_time.to_i) > DateTime.parse("May 29").to_time
    }
    @event_slice_3 = @events.select{|e|
      Time.at(e.start_time.to_i) < DateTime.parse("May 31").to_time && Time.at(e.start_time.to_i) > DateTime.parse("May 30").to_time
    }

    flickr = Flickr.new("#{Rails.root}/config/flickr.yml")
    # @photos = flickr.photos.search(:user_id => '91188732@N00', :photoset_id => '72157602116489467', :per_page => 10)
    @photoset = flickr.photosets.get_list(:user_id => FLICKR_USER_ID).detect{ |set| set.id == FLICKR_PHOTOSET_ID }
    @photos = @photoset.get_photos(:per_page => 10)
  end

  def update_attendant_panel
    event = fbsession.events_get(:eids => [params[:eid]]).event_list.first

    render :partial => "guide_event", :object => event
  end

  def gathering
    @current_tab = "Gatherings"
    @your_gatherings = Gathering.paginate(:all, :conditions => {:uid => @uid},
      :per_page => 2, :page => params[:page_your])
    @your_gathering_events = []
    event_eids = @your_gatherings.map{|e| Utils.get_event_eid e.event_link}
    unless event_eids.empty?
      @your_gathering_events = fbsession.events_get(:eids => event_eids).event_list
    end

    @all_gatherings = Gathering.paginate(:all, :conditions => ["uid <> ?", @uid],
      :per_page => PER_PAGE, :page => params[:page_your])
    @all_gathering_events = []
    event_eids = @all_gatherings.map{|e| e.eid.to_s}
    unless event_eids.empty?
      @all_gathering_events = fbsession.events_get(:eids => event_eids).event_list
    end
  end

  def create_gathering
    eid = Utils.get_event_eid(params[:gathering][:event_link])
    if !eid.blank?
      gathering = Gathering.new(params[:gathering])
      gathering.uid = @uid
      if gathering.save
        render :update do |page|
          page["gathering_form"].replace_html :partial => "gathering_form"
          page.alert("Your gathering has been created")
          page << gathering_publisher(gathering)
        end
      else
        render :update do |page|
          @gathering = gathering
          page.alert("Please check your information again")
          page["gathering_form"].replace_html :partial => "gathering_form"
        end
      end
    else
      render :update do |page|
        @gathering = gathering
        page.alert("Please check your information again")
        page["gathering_form"].replace_html :partial => "gathering_form"
      end
    end
  end

  def volunteer
    @current_tab = "Volunteer"
    @volunteer_uids = Volunteer.find(:all, :limit => PER_PAGE).collect{|v| v.uid}
    @page = 1
    @volunteers = fbsession.users_getInfo(:uids => @volunteer_uids, :fields => ["pic_square", "first_name", "profile_url"]).user_list
    @have_next_volunteer_page = Volunteer.count > PER_PAGE
    @volunteer = Volunteer.new
    @already_applied = Volunteer.find_by_uid(@uid)
  end

  def create_volunteer
    unless Volunteer.find_by_uid(@uid)
      @volunteer = Volunteer.new(params[:volunteer])
      @volunteer.uid = @uid
      @volunteer.save!
      flash[:notice] = "Your application has been submitted"
    end
    redirect_to :action => "volunteer"
  rescue
    @volunteer_uids = Volunteer.find(:all, :limit => PER_PAGE).collect{|v| v.uid}
    @page = 1
    @volunteers = fbsession.users_getInfo(:uids => @volunteer_uids, :fields => ["pic_square", "first_name", "profile_url"]).user_list
    @have_next_volunteer_page = Volunteer.count > PER_PAGE
    render :action => "volunteer"
  end

  def show_volunteer_page
    @page = params[:page] || 1
    @page = @page.to_i
    p_start = (@page - 1) * PER_PAGE

    @volunteer_uids = Volunteer.find(:all, :limit => PER_PAGE, :offset => p_start).collect{|v| v.uid}

    @volunteers = fbsession.users_getInfo(:uids => @volunteer_uids, :fields => ["pic_square", "first_name", "profile_url"]).user_list
    @have_next_volunteer_page = Volunteer.count > p_start + PER_PAGE
    render :partial => "youth/volunteer_panel"
  end

  def booking
    @current_tab = "Book ticket"
    @ticket_rsvp = Ticket.find_by_uid(@uid)
    @ticket = Ticket.new
    @page = 1
    uids = fbsession.friends_get.friend_list
    @friend_uids = uids[0...PER_PAGE]
    @have_next_friend_page = uids.size > @friend_uids.size

    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
  end

  def create_ticket
    unless Ticket.find_by_uid(@uid)
      @ticket = Ticket.new(params[:ticket])
      @ticket.uid = @uid
      @ticket.save!
      flash[:notice] = "Your ticket has been reserved"
    end
    redirect_to :action => "booking"
  rescue
    @page = 1
    uids = fbsession.friends_get.friend_list
    @friend_uids = uids[0...PER_PAGE]
    @have_next_friend_page = uids.size > @friend_uids.size

    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
    render :action => "booking"
  end

  def giveaway
    @current_tab = "Giveaway"
    @friend_uids = (fbsession.friends_get.friend_list)
    @exclude_friends = fbsession.users_getInfo(:uids => @friend_uids, :fields => ["uid"]).user_list.collect{|f| f.uid}
  end

  def event_list
    @events = Event.paginate(:all,
      :per_page => PER_PAGE, :page => params[:page])

    @event_infos = []
    event_eids = @events.map{|e| e.eid.to_s}
    unless event_eids.empty?
      @event_infos = fbsession.events_get(:eids => event_eids).event_list
    end
  end

  def gathering_list
    @gatherings = Gathering.paginate(:all,
      :per_page => PER_PAGE, :page => params[:page])

    @gathering_infos = []
    event_eids = @gatherings.map{|e| Utils.get_event_eid(e.event_link)}
    unless event_eids.empty?
      @gathering_infos = fbsession.events_get(:eids => event_eids).event_list
    end
  end

  def friend_list
    @uids = fbsession.friends_get.friend_list.paginate(params[:page], 10)
    @friend_uids = @uids
    @have_next_friend_page = @uids.size > @friend_uids.size

    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
  end

  def volunteer_list
    @uids = Volunteer.paginate(:all, :page => params[:page], :per_page => 20).map{|v| v.uid}

    @volunteers = fbsession.users_getInfo(:uids => @uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
  end
end
