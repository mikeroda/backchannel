require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "search" do
    get :search, :searchstr => 'searchstr'
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "edit" do
    get :edit, :id => posts(:one).to_param
    assert_response :success
  end

  test "create" do
    session[:user] = users(:mike)
    assert_difference('Post.count') do
      post :create, :post => { :message => 'new message' }
    end
    assert_redirected_to posts_path
  end

  test "update" do
    session[:user] = users(:mike)
    put :update, :id => posts(:one).to_param, :post => { }
    assert_redirected_to posts_path
  end

  test "destroy" do
    session[:user] = users(:mike)
    # this should cause a cascading delete of the replies also
    assert_difference('Post.count', -3) do
      delete :destroy, :id => posts(:one).to_param
    end

    assert_redirected_to posts_path
  end

  test "cheer" do
    session[:user] = users(:john)
    post :cheer, :post_id => posts(:one).id
    assert_redirected_to posts_path
  end

end
