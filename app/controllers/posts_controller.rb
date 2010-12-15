class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find_all_and_thread
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @post.post_id = params[:post_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/search
  # GET /posts/search.xml
  def search
    @posts = Post.search_and_thread(params[:searchstr])
    
    respond_to do |format|
      format.html { render(:template => "posts/index") }
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    success = false;
    if (session[:user])
      @post = Post.new(params[:post])
      @post[:user_id] = session[:user][:id]
      success = @post.save
    end
    
    respond_to do |format|
      if success
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { redirect_to(posts_url) }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    success = false;
    if (session[:user])
      @post = Post.find(params[:id])
      if (@post.user == session[:user])
        success = @post.update_attributes(params[:post])
      end
    end

    respond_to do |format|
      if success
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to posts_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    if (session[:user])
      @post = Post.find(params[:id])
      if (@post.user == session[:user] || session[:user].admin == 1)
        Post.destroyCascade(@post)
      end
    end
    
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

  # POST /posts/cheer
  # POST /posts/cheer.xml
  def cheer
    if (session[:user])
      @post = Post.find(params[:post_id])
      @cheer = @post.toggleCheer(session[:user])
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to(posts_url) }
        format.xml  { head :ok }
      else
        format.html { render(:action => "index") }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

end
