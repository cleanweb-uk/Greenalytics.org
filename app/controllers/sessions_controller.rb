# GREENALYTICS
# Session controller
# This controller handles the login/logout function of the site. 
# Created by Jorge L. Zapico // jorge@zapi.co // http://jorgezapico.com
# Created for the Center for Sustainable Communications More info at http://cesc.kth.se
# 2010
# Open Source License

 
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if user.gtoken
        redirect_back_or_default('/users/my_sites')
      else
        redirect_back_or_default('/connect')
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
  
 

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
