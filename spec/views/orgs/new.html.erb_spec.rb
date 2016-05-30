require 'rails_helper'

RSpec.describe "orgs/new", type: :view do
  before(:each) do
    assign(:org, Org.new(
      :name => "MyString",
      :location => nil
    ))
  end

  it "renders new org form" do
    render

    assert_select "form[action=?][method=?]", orgs_path, "post" do

      assert_select "input#org_name[name=?]", "org[name]"

      assert_select "input#org_location_id[name=?]", "org[location_id]"
    end
  end
end
