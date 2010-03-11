# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  
  before_filter :require_facebook_login  
  before_filter :get_current_uid

  private
  def get_current_uid
    @uid = fbsession.users_getLoggedInUser
  end
end
