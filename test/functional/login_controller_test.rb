require 'test_helper'

class LoginControllerTest < ActionController::TestCase

  test "index" do
    get :index
    assert_response :success
  end
  
  test "login" do
    user = users(:mike)

    # change the password so we know what it is
    user.password = 'mike'
    user.password_confirmation = 'mike'
    user.save
    
    # should login successful and redirect to posts path
    post :login, :name => 'mike', :password => 'mike' 
    assert_redirected_to posts_path

    # wrong password, should redirect back to index page
    post :login, :name => 'mike', :password => 'wrong' 
    assert_redirected_to :action => :index
  end

  test "logout" do
    session[:user] = users(:mike)
    post :logout
    assert_redirected_to :action => :index
    assert_nil session[:user]
  end
  
end
