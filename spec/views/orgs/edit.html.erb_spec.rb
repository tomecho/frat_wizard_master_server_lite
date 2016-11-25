require 'rails_helper'

RSpec.describe 'orgs/edit', type: :view do
  before { skip('dont do these') }
  before(:each) do
    @org = assign(:org, Org.create!(
                          name: 'MyString',
                          location: nil
    ))
  end

  it 'renders the edit org form' do
    render

    assert_select 'form[action=?][method=?]', org_path(@org), 'post' do
      assert_select 'input#org_name[name=?]', 'org[name]'

      assert_select 'input#org_location_id[name=?]', 'org[location_id]'
    end
  end
end
