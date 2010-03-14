# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  
  before_filter :require_facebook_login  
  before_filter :get_current_uid

  rescue_from RFacebook::FacebookSession::ExpiredSessionStandardError do
    redirect_to :controller => "youth", :action => "index"
  end

  private
  def get_current_uid
    @uid = fbsession.users_getLoggedInUser.to_s
  end
end
