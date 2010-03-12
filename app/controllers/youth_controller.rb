class YouthController < ApplicationController
  PER_PAGE = 4
  def index
    @featured_events = []
    @featured_gatherings = []
    friend_uids = fbsession.friends_get.friend_list[0..9]
    @friends = fbsession.users_getInfo(:uids => friend_uids,
            :fields => ["first_name", "pic_square", "profile_url"]).user_list

    featured_event_eids = Feature.find(:all,
      :conditions => {:f_type => "event"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    featured_gathering_eids = Feature.find(:all,
      :conditions => {:f_type => "gathering"}, :limit => PER_PAGE).map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @featured_events = fbsession.events_get(:eids => featured_event_eids).event_list
    end
    unless featured_gathering_eids.empty?
      @featured_gatherings = fbsession.events_get(:eids => featured_gathering_eids).event_list
    end
  end

  def about
  end

  def guide
  end

  def gathering
    @gatherings = Gathering.find(:all, :conditions => {:uid => @uid})
  end

  def create_gathering
    eid = Utils.get_event_eid
    unless eid.blank?
      gathering = Gathering.new(params[:gathering])
      gathering.uid = @uid
      gathering.save!
    end

    redirect_to :action => "gathering"
  end

  def volunteer
  end

  def booking
  end

  def giveaway
  end
end
