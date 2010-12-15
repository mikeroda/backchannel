class LoginController < ApplicationController

  def index
    @user = User.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user] = user
        redirect_to(posts_url)
      else
        flash[:notice] = "Invalid username/password combination"
        redirect_to :action => 'index'
      end
    end
  end

  def logout
    session[:user] = nil
        flash[:notice] = "You have logged out"
    redirect_to(:action => 'index')
  end
end
