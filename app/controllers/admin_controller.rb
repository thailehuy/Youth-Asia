class AdminController < ApplicationController
  PER_PAGE = 10

  def index
    redirect_to :action => "event_list"
  end

  def event_list
    page = params[:page] || 1
    @events = Feature.paginate(:all, :conditions => {:f_type => "event"},
      :page => page, :per_page => PER_PAGE)
  end

  def gathering_list
    page = params[:page] || 1
    @gatherings = Feature.paginate(:all, :conditions => {:f_type => "gathering"},
      :page => page, :per_page => PER_PAGE)
  end

  def make_feature
    eid = Utils.get_event_eid

    unless eid.blank? || Feature.find_by_eid(eid)
      feature = Feature.new(params[:feature])
      feature.eid = eid

      feature.save!
    end

    if params[:feature][:f_type] == "event"
      redirect_to :action => "event_list"
    else
      redirect_to :action => "gathering_list"
    end
  end
end
