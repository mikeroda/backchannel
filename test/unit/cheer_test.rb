require 'test_helper'

class CheerTest < ActiveSupport::TestCase

  test "verify uniqueness" do
    post = posts(:three)
    
    # mike already cheered post three so this should fail
    cheer = Cheer.new(post, users(:mike))
    assert !cheer.valid?
    
    # but admin should be able to cheer it
    cheer = Cheer.new(post, users(:admin))
    assert cheer.valid?
  end
end
