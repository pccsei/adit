require 'spec_helper'

describe "actions/new" do
  before(:each) do
    assign(:action, stub_model(Action).as_new_record)
  end

  it "renders new action form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", actions_path, "post" do
    end
  end
end
