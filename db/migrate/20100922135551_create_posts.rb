class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id, :null => false, :options =>
        "CONSTANT fk_posts_users REFERENCES users(id)"
      t.integer :post_id, :null => true, :options =>
        "CONSTANT fk_posts_posts REFERENCES posts(id)"
      t.string :message, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
