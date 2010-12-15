require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "invalid with empty attributes" do
    post = Post.new
    assert !post.valid?
    assert post.errors.invalid?(:message)
    assert post.errors.invalid?(:user)
  end
  
  test "verify ordering of posts" do
    posts = Post.find_all_and_thread
    assert_equal 6, posts.size
    assert_equal "this is the fourth main post", posts[0].message
    assert_equal "this is the third main post", posts[1].message
    assert_equal "this is the second main post", posts[2].message
    assert_equal "this is the first main post", posts[3].message
    assert_equal "this is a reply to the first post", posts[4].message
    assert_equal "another reply to the first post", posts[5].message
  end

  test "cheer your own post" do
    post = posts(:one)
    user = users(:mike)
    
    post.toggleCheer(user)
    assert_equal "Cannot cheer your own post", post.errors.on(:cheers)
  end
  
  test "search" do
    # search returning a single post
    assert_equal 1, Post.search_and_thread('this is the second main post').size

    # all the main posts plus their replies
    assert_equal 6, Post.search_and_thread('main').size

    # check for case-insensitivity
    assert_equal 6, Post.search_and_thread('MAIN').size

    # three posts by mike and includes one additional reply
    assert_equal 4, Post.search_and_thread('mike').size
    
    # one post with 'another' in it, plus its parent
    assert_equal 3, Post.search_and_thread('another').size

    # no matches on this
    assert_equal 0, Post.search_and_thread('xxyyxx').size

    # search on 'reply' and verify ordering
    posts = Post.search_and_thread("reply")
    assert_equal 3, posts.size
    assert_equal "this is the first main post", posts[0].message
    assert_equal "this is a reply to the first post", posts[1].message
    assert_equal "another reply to the first post", posts[2].message
  
  end

end
