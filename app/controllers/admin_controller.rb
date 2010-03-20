class AdminController < ApplicationController
  before_filter :check_admin
  layout "admin"
  PER_PAGE = 4

  def index
    redirect_to :action => "event_list"
  end

  def event_list
    @events = Event.paginate(:all,
      :per_page => PER_PAGE, :page => params[:page])

    @event_infos = []
    featured_event_eids = @events.map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @event_infos = fbsession.events_get(:eids => featured_event_eids).event_list
    end
  end

  def featured_event_list
    @events = Feature.paginate(:all, :conditions => {:f_type => "event"},
      :per_page => PER_PAGE, :page => params[:page])

    @event_infos = []
    featured_event_eids = @events.map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @event_infos = fbsession.events_get(:eids => featured_event_eids).event_list
    end
  end

  def gathering_list
    @gatherings = Gathering.paginate(:all,
      :per_page => PER_PAGE, :page => params[:page])

    @gathering_infos = []
    featured_event_eids = @gatherings.map{|e| e.eid}
    unless featured_event_eids.empty?
      @gathering_infos = fbsession.events_get(:eids => featured_event_eids).event_list
    end
  end

  def featured_gathering_list
    @gatherings = Feature.paginate(:all, :conditions => {:f_type => "gathering"},
      :per_page => PER_PAGE, :page => params[:page])
    @gathering_infos = []
    featured_event_eids = @gatherings.map{|e| e.eid.to_s}
    unless featured_event_eids.empty?
      @gathering_infos = fbsession.events_get(:eids => featured_event_eids).event_list
    end
  end

  def volunteer_list
    @volunteers = Volunteer.paginate(:all,
      :per_page => PER_PAGE, :page => params[:page])
  end

  def make_feature
    eid = Utils.get_event_eid(params[:event_link])

    unless eid.blank? || Feature.find_by_eid(eid)
      feature = Feature.new(:eid => eid, :event_link => params[:event_link], :f_type => params[:f_type])
      feature.eid = eid

      feature.save!
    end

    if params[:f_type] == "event"
      redirect_to :action => "event_list"
    else
      redirect_to :action => "gathering_list"
    end
  end

  def make_event
    eid = !params[:event][:link].blank? && Utils.get_event_eid(params[:event][:link])
    @event = Event.find_or_create_by_eid(eid)
    if @event.update_attributes(params[:event])
      redirect_to :action => "event_list"
    else
      event_list
      render :action => "event_list"
    end
  end

  def remove_feature
    feature = Feature.find_by_eid(params[:eid])
    f_type = "event"
    if feature
      if feature.f_type == "gathering"
        f_type = "gathering"
      end
      feature.destroy
    end
    redirect_to :action => "#{f_type}_list"
  end

  def download_cv
    volunteer = Volunteer.find_by_id(params[:v_id])
    if volunteer
      send_file volunteer.public_filename
    else
      render :nothing => true
    end
  end

  def cms
    @content = Content.first
    unless @content
      @content = Content.create
    end
  end

  def update_content
    @content = Content.first
    if @content.update_attributes(params[:content])
      flash[:notice] = "Content updated"
      redirect_to :action => "cms"
    else
      flash[:error] = "Error updating content"
      render :action => "cms"
    end
  end

  private
  def check_admin
    true
  end
end
