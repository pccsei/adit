require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test "business name must not be empty" do
    client = Client.new
    assert client.invalid?
    assert client.errors[:business_name].any?
  end
  test "address must not be empty" do
    client = Client.new
    assert client.invalid?
    assert client.errors[:address].any?
  end
end
