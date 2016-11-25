require 'rails_helper'

RSpec.describe "orgs/show", type: :view do
  before { skip('not yet') }
  before(:each) do
    @org = assign(:org, Org.create!(
      :name => "Name",
      :location => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
