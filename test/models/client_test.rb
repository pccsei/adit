require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  fixtures :clients
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
  test "telephone must be unique" do
    client = Client.new(id: 4,
                        business_name: "MyText",
                        address: "MyText",
                        email: "MyText",
                        website: "MyText",
                        contact_name: "MyText",
                        telephone: clients(:two).telephone,
                        comment: "MyText",
                        created_at: "2013-11-06 08:26:14",
                        updated_at: "2013-11-06 08:26:14")
    assert client.invalid?
    assert_equal ["has already been taken"], client.errors[:telephone]
  end
end