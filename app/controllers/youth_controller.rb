class YouthController < ApplicationController
  PER_PAGE = 4

  def landing
    InvitationCount.find_or_create_by_uid_and_invited_uid(params[:from_ref], @uid) unless @uid.to_s == params[:from_ref].to_s
    redirect_to :action => "index"
  end

  def index
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
  end
  #filter
  # date 1-2-3 = today +1 +2
  # cat 1-2-3-4 = category
  def guide
    @cat = params[:cat].to_i
    if @cat > 0 && @cat < 5
      events = Event.find(:all, :condition => {:category => Event::CATEGORIES[@cat - 1]})
    else
      events = Event.find(:all)
    end
    event_eids = events.map{|e| e.eid.to_s}

    @date = params[:date].to_i
    if @date > 0 && @date < 4
      date_offset = @date - 1
    else
      date_offset = 0
    end
    start_date = (Date.today + date_offset.days).to_time.to_i
    @page = params[:page] || 1
    @page = @page.to_i
    p_start = (@page - 1) * PER_PAGE
    p_end = @page * PER_PAGE
    event_list = []
    event_list = fbsession.events_get(:eids => event_eids, :start_time => start_date).event_list unless event_eids.blank?
    @events = event_list[p_start...p_end]

    @have_next_event_page = event_list.size >= p_end
  end

  def gathering
    @gatherings = Gathering.find(:all, :conditions => {:uid => @uid})
  end

  def create_gathering
    eid = Utils.get_event_eid
    if !eid.blank?
      gathering = Gathering.new(params[:gathering])
      gathering.uid = @uid
      if gathering.save
        flash[:notice] = "Gathering created"
      else
        flash[:error] = "Fail to create gathering, please try again"
      end
    end

    redirect_to :action => "gathering"
  end

  def volunteer

  end

  def create_volunteer
    volunteer = Volunteer.new(params[:volunteer])
    volunteer.uid = @uid
    volunteer.save!

    redirect_to :action => "volunteer"
  end

  def booking
  end

  def giveaway
    @friend_uids = (fbsession.friends_get.friend_list)
    @exclude_friends = fbsession.users_getInfo(:uids => @friend_uids, :fields => ["uid"]).user_list.collect{|f| f.uid}
  end
end
