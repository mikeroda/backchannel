class CreateCheers < ActiveRecord::Migration
  def self.up
    create_table :cheers do |t|
      t.integer :user_id, :null => false, :options =>
        "CONSTANT fk_cheers_users REFERENCES users(id)"
      t.integer :post_id, :null => true, :options =>
        "CONSTANT fk_cheers_posts REFERENCES posts(id)"

      t.timestamps
    end
  end

  def self.down
    drop_table :cheers
  end
end
