require 'test_helper'

class UserTest < ActiveSupport::TestCase
  user = User.new
  test "User must have an ID" do
    assert user.invalid?
    assert user.errors[:school_id].any?
  end
  
  test "User must have an email" do
    assert user.invalid?
    assert user.errors[:email].any?
  end
  
  test "User must have a phone" do
    assert user.invalid?
    assert user.errors[:phone].any?
  end
  
  test "User must have a unique ID" do
    assert user.invalid?
    assert_equal ["has already been taken"], user.errors[:school_id]
  end
end
