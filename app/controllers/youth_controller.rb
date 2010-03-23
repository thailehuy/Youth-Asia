class YouthController < ApplicationController
  PER_PAGE = 4

  FRIEND_PER_PAGE = 10

  def landing
    InvitationCount.find_or_create_by_uid_and_invited_uid(params[:from_ref], @uid) unless @uid.to_s == params[:from_ref].to_s
    top_redirect_to :action => "index"
  end

  def index
    if request.xml_http_request?
      if params[:friend_page]
        uids = fbsession.friends_getAppUsers.uid_list
        @friend_uids = uids.paginate(:page => params[:friend_page], :per_page => FRIEND_PER_PAGE)
        @friends = fbsession.users_getInfo(:uids => @friend_uids,
                :fields => ["first_name", "pic_square", "profile_url"]).user_list
        render :partial => "youth/friend_panel"
      elsif params[:event_page]
        @featured_events = []
        @features = Feature.paginate(:all,
              :page => params[:event_page], :per_page => PER_PAGE,
              :conditions => {:f_type => "event"})
        @featured_event_eids = @features.map{|e| e.eid.to_s}
        unless @featured_event_eids.empty?
          @featured_events = fbsession.events_get(:eids => @featured_event_eids).event_list
        end
        render :partial => "youth/event_panel"
      elsif params[:gathering_page]
        @featured_gatherings = []
        @gatherings = Feature.paginate(:all,
              :page => params[:event_page], :per_page => PER_PAGE,
              :conditions => {:f_type => "gathering"})
        @featured_gathering_eids = @gatherings.map{|e| e.eid.to_s}
        unless @featured_gathering_eids.empty?
          @featured_gatherings = fbsession.events_get(:eids => @featured_gathering_eids).event_list
        end
      else
        render :nothing => true
      end
      return
    else
      @current_tab = "Home"
      @featured_events = []
      @featured_gatherings = []
      uids = fbsession.friends_getAppUsers.uid_list
      @friend_uids = uids.paginate(:page => params[:friend_page], :per_page => FRIEND_PER_PAGE)
      @friends = fbsession.users_getInfo(:uids => @friend_uids,
              :fields => ["first_name", "pic_square", "profile_url"]).user_list

      @features = Feature.paginate(:all,
              :page => params[:event_page], :per_page => PER_PAGE,
              :conditions => {:f_type => "event"})
      @featured_event_eids = @features.map{|e| e.eid.to_s}
      unless @featured_event_eids.empty?
        @featured_events = fbsession.events_get(:eids => @featured_event_eids).event_list
      end
      
      @featured_gatherings = []
      @gatherings = Feature.paginate(:all,
            :page => params[:event_page], :per_page => PER_PAGE,
            :conditions => {:f_type => "gathering"})
      @featured_gathering_eids = @gatherings.map{|e| e.eid.to_s}
      unless @featured_gathering_eids.empty?
        @featured_gatherings = fbsession.events_get(:eids => @featured_gathering_eids).event_list
      end
    end
  end

  def about
    @current_tab = "About"
  end
  #filter
  def guide
    @current_tab = "Festival Guide"
    all_events = Event.all

    events = []
    zero_cat = true
    Event::CATEGORIES.each_with_index do |cat, index|
      if params["cat#{index + 1}".to_sym].to_i == 1
        events += all_events.select{|e| e.category == cat}
        zero_cat = false
      end
    end

    events = all_events if zero_cat
    
    if params["date1".to_sym].to_i == 0 && params["date2".to_sym].to_i == 0 && params["date3".to_sym].to_i == 0
      start_date = nil
      end_date = nil
    else
      start_date_offset = 0
      end_date_offset = 0

      (1..3).to_a.each do |index|
        if params["date#{index}".to_sym].to_i == 1
          start_date_offset += (index - 1) unless start_date_offset > 0
          end_date_offset += (index - 1)
        end
      end
      start_date = (DateTime.parse("May 28") + start_date_offset.days).to_time.to_i
      end_date = (DateTime.parse("May 29") + end_date_offset.days).to_time.to_i
    end

    
    @events = []
    unless events.blank?
      @events = fbsession.events_get(:eids => events.collect{|e| e.eid},
                :start_time => start_date, :end_time => end_date).event_list
    end

    flickr = Flickr.new("#{Rails.root}/config/flickr.yml")
    # @photos = flickr.photos.search(:user_id => '91188732@N00', :photoset_id => '72157602116489467', :per_page => 10)
    @photoset = flickr.photosets.get_list(:user_id => FLICKR_USER_ID).detect{ |set| set.id == FLICKR_PHOTOSET_ID }
    @photos = @photoset.get_photos(:per_page => 6)
  end

  def all_attendees
    if !params[:eid].blank?
      @uids = fbsession.events_getMembers(:eid => params[:eid]).attending.uid_list
      @attendess = fbsession.users_getInfo(:uids => @uids,
                :fields => ["first_name", "pic_square", "profile_url"]).user_list
    else
      redirect_to :action => "index"
    end
  end

  def update_attendant_panel
    event = fbsession.events_get(:eids => [params[:eid]]).event_list.first

    render :partial => "guide_event", :object => event
  end

  def gathering
    if request.xml_http_request?
      if params[:page_all]
        get_all_gathering
        render :partial => "youth/all_gathering"
      elsif params[:page_your]
        get_your_gathering
        render :partial => "youth/your_gathering"
      else
        render :nothing => true
      end
      return
    else

    end
    @current_tab = "Youth Gatherings"
    get_your_gathering
    get_all_gathering

    @gathering = Gathering.new
  end

  def create_gathering
    @gathering = Gathering.new(params[:gathering])
    if params[:gathering].nil?
      render :update do |page|
        page.alert("Please check your information again")
        page["gathering_form"].replace_html :partial => "gathering_form"
      end
      return
    end
    eid = Utils.get_event_eid(params[:gathering][:event_link])

    if eid.blank?
      render :update do |page|
        page.alert("Event link is incorrect")
        page["gathering_form"].replace_html :partial => "gathering_form"
      end
      return
    end

    dup = Gathering.find_by_eid(eid)
    @gathering.uid = @uid
    @gathering.eid = eid
    if !dup && @gathering.save
      get_your_gathering
      render :update do |page|
        page["gathering_form"].replace_html :partial => "gathering_form"
        page["your_gathering"].replace_html :partial => "your_gathering"
        page.alert("Your gathering has been created")
        page << gathering_publisher(@gathering)
      end
    else
      render :update do |page|
        if dup
          page.alert("The same event has already been registered")
        else
          page.alert("Please check your information again")
        end
        page["gathering_form"].replace_html :partial => "gathering_form"
      end
    end
  end

  def volunteer
    @current_tab = "Volunteer"
    paginate_volunteer
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
    top_redirect_to :action => "volunteer"
  rescue
    paginate_volunteer
    render :action => "volunteer"
  end

#  def show_volunteer_page
#    @page = params[:page] || 1
#    @page = @page.to_i
#    p_start = (@page - 1) * PER_PAGE
#
#    @volunteer_uids = Volunteer.find(:all, :limit => PER_PAGE, :offset => p_start).collect{|v| v.uid}
#
#    @volunteers = fbsession.users_getInfo(:uids => @volunteer_uids, :fields => ["pic_square", "first_name", "profile_url"]).user_list
#    @have_next_volunteer_page = Volunteer.count > p_start + PER_PAGE
#    render :partial => "youth/volunteer_panel"
#  end

  def booking
    @current_tab = "Book ticket"
#    @ticket_rsvp = Ticket.find_by_uid(@uid)
#    @ticket = Ticket.new
    uids = fbsession.friends_getAppUsers.uid_list
    @friend_uids = uids.paginate(:page => params[:page], :per_page => FRIEND_PER_PAGE)

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
    top_redirect_to :action => "booking"
  rescue
    @page = 1
    uids = fbsession.friends_getAppUsers.uid_list
    @friend_uids = uids[0...PER_PAGE]
    @have_next_friend_page = uids.size > @friend_uids.size

    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
    render :action => "booking"
  end

  def giveaway
    @current_tab = "Invite Friends"
    @friend_uids = (fbsession.friends_getAppUsers.uid_list)
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
    @uids = fbsession.friends_getAppUsers.uid_list.paginate(:page => params[:page], :per_page => 10)
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

  def invite_fb_friends
    friend_uids = fbsession.friends_getAppUsers.uid_list
    success = fbsession.events_invite(:eid => params[:eid], :uids => friend_uids)

    render :update do |page|
      if success
        page.alert("Invitations sent to all your friends in Youth '10")
      else
        page.alert("Something went wrong, please try again")
      end
    end
  end

  def send_mail
    if !params[:name].blank? && params[:name] != "Name" && !params[:reason].blank? && params[:reason] != "What do you want to tell us?"
      UserMailer.deliver_contact_submit(params[:name], params[:email], params[:reason])
    end

    redirect_to :action => "contact"
  end

  protected
  def get_your_gathering
    @your_gatherings = Gathering.paginate(:all, :conditions => {:uid => @uid},
      :per_page => 2, :page => params[:page_your])
    @your_gathering_events = []
    event_eids = @your_gatherings.map{|e| Utils.get_event_eid e.event_link}
    unless event_eids.empty?
      @your_gathering_events = fbsession.events_get(:eids => event_eids).event_list
    end
  end

  def get_all_gathering
    @all_gatherings = Gathering.paginate(:all, :conditions => ["eid <> ''"],
      :per_page => PER_PAGE, :page => params[:page_all])
    @all_gathering_events = []
    event_eids = @all_gatherings.map{|e| e.eid}.compact
    unless event_eids.empty?
      @all_gathering_events = fbsession.events_get(:eids => event_eids).event_list
    end
  end

  def paginate_volunteer
    @volunteer_uids = Volunteer.paginate(:all, :page => params[:page], :per_page => FRIEND_PER_PAGE)
    uids = @volunteer_uids.collect{|v| v.uid}
    @volunteers = fbsession.users_getInfo(:uids => uids, :fields => ["pic_square", "first_name", "profile_url"]).user_list
  end
end
