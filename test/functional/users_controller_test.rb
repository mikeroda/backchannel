require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "index" do
    # first attempt without login, should redirect to login page
    get :index
    assert_redirected_to :controller => :login, :action => :index
    assert_equal "Please log in", flash[:notice]
 
    # regular user, should redirect to login page
    session[:user] = users(:mike)
    get :index
    assert_redirected_to :controller => :login, :action => :index
    assert_equal "Please log in", flash[:notice]

    # admin, should be successful
    session[:user] = users(:admin)
    get :index
    assert_response :success
  end

  test "edit" do
    get :edit, :id => users(:mike).to_param
    assert_response :success
  end

  test "create" do
    # create user and redirect to posts
    assert_difference('User.count') do
      post :create, :user => { :name => 'name', :password => 'password', :password_confirmation => 'password' }
    end
    assert_redirected_to :controller => :posts, :action => :index

    # not successfully create user, redirect to login
    post :create, :user => { :name => 'name', :password => '', :password_confirmation => 'password' }
    assert_template 'login/index'
  end

  test "update" do
    # user updating himself should redirect to posts path
    session[:user] = users(:mike)
    put :update, :id => users(:mike).to_param, :user => { }
    assert_redirected_to posts_path

    # admin updating user should redirect to users path
    session[:user] = users(:admin)
    put :update, :id => users(:mike).to_param, :user => { }
    assert_redirected_to users_path
  end

  test "destroy" do
    # should not destroy since not logged in
    assert_no_difference('User.count', -1) do
      delete :destroy, :id => users(:mike).to_param
    end

    # should not destory since not logged in as admin
    session[:user] = users(:mike)
    assert_no_difference('User.count', -1) do
      delete :destroy, :id => users(:mike).to_param
    end

    # should destroy since logged in as admin
    session[:user] = users(:admin)
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:mike).to_param
    end
    assert_redirected_to users_path
  end

  test "newAdmin" do
    get :newAdmin
    assert_response :success
  end

  test "createAdmin" do
    # should not create admin since not logged in
    assert_no_difference('User.count') do
      post :createAdmin, :user => { :name => 'name', :password => 'password', :password_confirmation => 'password' }
    end

    # should not create admin since not logged in as admin
    session[:user] = users(:mike)
    assert_no_difference('User.count') do
      post :createAdmin, :user => { :name => 'name', :password => 'password', :password_confirmation => 'password' }
    end

    # create admin and redirect to users_path
    session[:user] = users(:admin)
    assert_difference('User.count') do
      post :createAdmin, :user => { :name => 'name', :password => 'password', :password_confirmation => 'password' }
    end
    assert_redirected_to users_path
  end

end
