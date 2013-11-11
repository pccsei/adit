require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User cannot be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?
    assert user.errors[:school_id].any?
    assert user.errors[:email].any?
    assert user.errors[:phone].any?
  end
end
