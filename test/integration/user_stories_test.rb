require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :all

  # Test the various posting functionality
  test "posting" do
    visit "/"
    assert_contain "Backchannel Application"
    
    # login
    fill_in "user[name]", :with => "newuser"
    fill_in "user[password]", :with => "password"
    fill_in "user[password_confirmation]", :with => "password"
    click_button "Add User"
    assert_contain "User newuser was successfully created."

    # make a post
    fill_in "post[message]", :with => "this is a post"
    click_button "New Post"
    assert_contain "Post was successfully created."
    assert_contain "this is a post"

    # edit the post
    click_link "Edit"
    fill_in "Message", :with => "this is my first post"
    click_button "Update"
    assert_contain "Post was successfully updated."
    assert_contain "this is my first post"

    # delete the post
    click_link "Delete"
    assert_not_contain "this is my first post"
    
    # reply to another post
    click_link "Reply"
    fill_in "Message", :with => "this is a reply"
    click_button "Create"
    assert_contain "Post was successfully created."
    assert_contain "this is a reply"

    # cheer a post
    click_link "Cheer"
    assert_contain "Uncheer"
    assert_contain "1 Cheer"

    # uncheer a post
    click_link "Uncheer"
    assert_not_contain "Uncheer"

    # logout
    click_link "Logout"
    assert_contain "You have logged out"
  end

  # test the search functionality
  test "search" do
    visit "/"
    fill_in "searchstr", :with => "main post"
    click_button "Search"
    assert_contain "this is the first main post"
    assert_contain "this is the second main post"
    assert_contain "this is the third main post"
    assert_contain "this is the fourth main post"
    assert_contain "another reply to the first post"
    assert_contain "this is a reply to the first post"

    fill_in "searchstr", :with => "first main post"
    click_button "Search"
    assert_contain "this is the first main post"
    assert_contain "another reply to the first post"
    assert_contain "this is a reply to the first post"
    assert_not_contain "this is the second main post"
    assert_not_contain "this is the third main post"
    assert_not_contain "this is the fourth main post"

    fill_in "searchstr", :with => "reply"
    click_button "Search"
    assert_contain "this is the first main post"
    assert_contain "another reply to the first post"
    assert_contain "this is a reply to the first post"
    assert_not_contain "this is the second main post"
    assert_not_contain "this is the third main post"
    assert_not_contain "this is the fourth main post"

    fill_in "searchstr", :with => "mike"
    click_button "Search"
    assert_contain "this is the first main post"
    assert_contain "this is the third main post"
    assert_contain "this is a reply to the first post"
    assert_contain "another reply to the first post"
    assert_not_contain "this is the second main post"
    assert_not_contain "this is the fourth main post"
  end
end
