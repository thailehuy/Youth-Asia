class YouthController < ApplicationController
  PER_PAGE = 4
  def index
    @page = 1
    @featured_events = []
    @featured_gatherings = []
    @friend_uids = (fbsession.friends_get.friend_list)[0...PER_PAGE]
    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list

    featured_event_eids = Feature.find(:all,
      :conditions => {:f_type => "event"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @featured_events = fbsession.events_get(:eids => featured_event_eids).event_list
    end

    featured_gathering_eids = Feature.find(:all,
      :conditions => {:f_type => "gathering"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    unless featured_gathering_eids.empty?
      @featured_gatherings = fbsession.events_get(:eids => featured_gathering_eids).event_list
    end
  end

  def show_friend_page
    @page = params[:page] || 1
    p_start = (@page.to_i - 1) * PER_PAGE
    p_end = @page.to_i * PER_PAGE
    @friend_uids = (fbsession.friends_get.friend_list)[p_start...p_end]
    @friends = fbsession.users_getInfo(:uids => @friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list
    render :partial => "youth/friend_panel"
  end

  def show_event_page
    @featured_events = []
    @page = params[:page] || 1
    p_start = (@page.to_i - 1) * PER_PAGE
    
    featured_event_eids = Feature.find(:all,
      :conditions => {:f_type => "event"}, :limit => PER_PAGE, :offset => p_start).map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @featured_events = fbsession.events_get(:eids => featured_event_eids).event_list
    end
    render :partial => "youth/event_panel"
  end

  def show_gathering_page
    @featured_gatherings = []
    @page = params[:page] || 1
    p_start = (@page.to_i - 1) * PER_PAGE

    featured_gathering_eids = Feature.find(:all,
      :conditions => {:f_type => "gathering"}, :limit => PER_PAGE, :offset => p_start).map{|e| e.eid.to_s}
    unless featured_gathering_eids.empty?
      @featured_gatherings = fbsession.events_get(:eids => featured_gathering_eids).event_list
    end
    render :partial => "youth/gathering_panel"
  end

  def about
  end

  def guide
    event_eids = Event.find(:all, :limit => PER_PAGE).map{|e| e.eid.to_s}
    @events = fbsession.events_get(:eids => event_eids, :start_time => Date.today, :end_time => Date.today + 3).event_list
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
    @exclude_friend_ids = (fbsession.friends_get.friend_list)
  end
end
