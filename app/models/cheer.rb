class Cheer < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_uniqueness_of :user_id, :scope => "post_id", :message => "Cannot cheer same post twice"

  def initialize(post, user)
    super()
    self.post = post
    self.user = user
  end

  def self.destroyCascade(cheer)
    cheer.destroy
  end

end
