class Post < ActiveRecord::Base
  belongs_to :user
  has_many :cheers
  has_one :post
  belongs_to :post
  
  validates_presence_of :message, :user
  
  # Find all posts and order them such that top-level posts are in ascending order of their
  # create date, with replies immediately following their parent post and in ascending order
  # of their create date - uh...basically the order that you want them to show in the view
  def self.find_all_and_thread
    # this crazy outer join allows me to sort the posts by the created date such that replies 
    # are sorted by the created date of their parent first, and then by their own created date 
    # second.
    posts = find(:all, 
                 :joins => "left outer join posts as posts2 on posts.post_id = posts2.id",
                 :order => "ifnull(posts2.created_at, posts.created_at) desc, posts.created_at asc")

   # another way I could have done it...but this relies on the IDs being sequentially assigned
   # by the database, which I found out isn't true during the units tests!
   # find(:all, :order => "ifnull(post_id, id) desc, created_at asc")
  end
  
  # Find all posts whose message or user name contains the search string. Any replies returned 
  # should include the parent regardless if the parent was a match, and likewise any parent that
  # matched should include all of its replies. Ordered same as the find_all_and_thread method (see above).
  def self.search_and_thread(searchstr)
    # find posts with with the search string in the message
    # we really 
    sqlwhere = "posts.message like '%#{searchstr}%' or users.name like '%#{searchstr}%'"
    posts = find(:all, 
                 :conditions => sqlwhere,
                 :joins => "inner join users on posts.user_id = users.id left outer join posts as posts2 on posts.post_id = posts2.id",
                 :order => "ifnull(posts2.created_at, posts.created_at) desc, posts.created_at asc")

    # loop through the posts we found to make sure we have the parent posts
    # for any replies that were returned by the query
    for i in 0 ... posts.size
      if (!posts[i].post_id.nil?)
        found = false
        for j in 0 ... posts.size
          if (posts[j].id == posts[i].post_id)
            found = true
            break
          end
        end

        # if we don't have the parent, go get it
        if (!found)
          post = find(posts[i].post_id)
          if (post)
            # replace the reply with its parent post, we have to get all the replies later anyway
            posts[i] = post
          end
        end
      end
    end
    
    # remove any remaining replies before we get them
    posts.delete_if {|p| !p.post_id.nil? }

    # now go through the array of parent-only posts and get all the replies
    i = 0
    while i < posts.size
      replies = find(:all, 
                     :conditions => [ "post_id = ?", posts[i].id ],
                     :order => "created_at desc")
      replies.each {|r| posts.insert(i + 1, r) }
      i = i + replies.size + 1
    end
 
    posts
  end
 
  # toggle the cheer/uncheer a post for the specified user
  def toggleCheer(user)
    if (user_id == user.id) 
      errors.add(:cheers, 'Cannot cheer your own post')
    else
      found = false
    
      for i in 0 ... cheers.size
        if (cheers[i].user_id == user.id)
          cheers[i].delete
          cheers.delete_at(i)
          found = true
        end
      end
    
      if (!found)
        cheer = Cheer.new(self, user)
        cheers << cheer
        cheer
      end
    end
  end

  def self.destroyCascade(post)
    cheers = Cheer.find( :all, :conditions => [ "post_id = ?", post.id ] )  
    for n in 0 ... cheers.size do
      Cheer.destroyCascade(cheers[n])
    end
    
    posts = Post.find( :all, :conditions => [ "post_id = ?", post.id ] )  
    for m in 0 ... posts.size do
      Post.destroyCascade(posts[m])
    end
    
    post.destroy
  end

end
