Backchannel application
==========================

Twitter may be used a back channel during lectures but as a back channel, Twitter has some important limitations.

1. You cannot search for posts by new people for a few days after they sign up.
2. Theres no way to identify oneself unless you have your own (public) Twitter account.
3. There's no easy way to figure out how many posts an individual has done; you have to aggregate the results and use external software.
4. There's no rating system for posts.
5. There's no threading; all replies appear in the same linear stream.
6. Account administration is up to Twitter, not up to us.  We have no defense against spam.

Using Ruby on Rails, we will create an application to address these shortcomings.

Features
========

1. Anyone can create an account by filling out a form that comes up on the homepage of the app.
2. Any user with an account can post, and may edit or delete their own posts.
3. Anyone (account or not) can search by user or content, by using the Search box on the homepage.
     *  Searches return matching posts and their replies, or their parent if the matching post is a reply itself
4. Any logged-in user can cheer (or uncheer) any post.
     *  The system maintains a count of cheers for each post.
     *  When the system displays a post, next to the post should be the number of cheers.
     *  You cannot cheer your own posts, and you cannot uncheer somebody else's cheer
5. Any logged-in user can reply to a post (but not to a reply; i.e., only to a depth of 1).
     *  A user can also cheer a reply (by someone else).
     *  A user can reply to his own post.
     *  Top-level (depth 0) posts are sorted most recent first. Reply posts (depth 1) are shown under their parent post, sorted oldest first.
     *  All deletes are cascaded to cleanup foreign key relationships.
7. If a user logs in as an admin, (s)he sees a different interface from what non-admins see.
     *  The first account is automatically made an administrator. After logging in, an administrator will see links to administer accounts and access reports from the posts index page.
     *  Administrators can create other admin accounts.
     *  Administrators can delete posts and users.
     *  View reports on post activity, including number of cheers for each post such that it is possible to use this report to assign grades.
     *  Any administrator can edit any other account, but can only edit himself from the link on the posts index page.
     *  Administrators cannot delete the account they are logged in as.
     *  Administrators can create new posts and reply to posts also.

Testing
=======

1. Test::Unit
2. Integration tests (requires webrat)

Software Requirement
====================
    * Ruby 1.8.7
    * Rails 2.3.8 (and associated dependencies). Do not use Ruby 3.0.
    * SQLite 3.7.2 (on Windows, place the DLL and DEF file in C:\Ruby187\bin)

Limitations / Suggestions for enhancements
==========================================

1. There is no paging through the posts.
2. You have to manually refresh the posts index, it doesn't do it automatically.
    