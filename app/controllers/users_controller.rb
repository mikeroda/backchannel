class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    if (session[:user] && session[:user].admin == 1)
       @users = User.all

       respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @users }
       end
     else
       flash[:notice] = "Please log in"
       redirect_to(:controller => 'login', :action => 'index')
     end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if (User.all().size == 0)
      @user.admin = 1
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        session[:user] = @user
        format.html { redirect_to(posts_url) }
      else
        format.html { render(:template => "login/index") }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
       end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    success = false
    if (session[:user] == @user || session[:user].admin == 1)
      success = @user.update_attributes(params[:user])
      if (success && session[:user].id == @user.id)
        session[:user] = @user
      end
    end
        
    respond_to do |format|
      if success
        flash[:notice] = "User was successfully updated."
        if (session[:user] == @user)
          format.html { redirect_to (posts_url) }
        else
          format.html { redirect_to (users_url) }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if (session[:user] && session[:user].admin == 1)
      User.destroyCascade(@user)
    end
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # GET /posts/newAdmin
  # GET /posts/newAdmin.xml
  def newAdmin
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users/createAdmin
  # POST /users/createAdmin.xml
  def createAdmin
    success = false
    @user = User.new(params[:user])
    if (!session[:user] || session[:user].admin == 0)
        flash[:notice] = "Only administrators can create administrators"
    else
      success = @user.save
    end

    respond_to do |format|
      if success
        flash[:notice] = "Administratyor #{@user.name} was successfully created."
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "newAdmin" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
