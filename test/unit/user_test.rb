require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "invalid with empty attributes" do
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:name)
  end
  
  test "passwords do not match" do
    user = User.new
    user.name = "name1"
    user.password = "password1"
    user.password_confirmation = "password2"
    assert !user.valid?
    assert user.errors.invalid?(:password)
    assert_equal "doesn't match confirmation", user.errors.on(:password)
  end

  test "passwords match" do
    user = User.new
    user.name = "name1"
    user.password = "password1"
    user.password_confirmation = "password1"
    assert user.valid?
  end
  
  test "authenticate" do
    user = User.new
    user.name = "name1"
    user.password = "password1"
    user.password_confirmation = "password1"
    user.save
    assert_not_nil User.authenticate(user.name, user.password)
    assert_nil User.authenticate(user.name, "junk")
  end
end
