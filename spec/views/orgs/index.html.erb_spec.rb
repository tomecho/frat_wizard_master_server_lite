require 'rails_helper'

RSpec.describe 'orgs/index', type: :view do
  before { skip('not yet') }
  before(:each) do
    assign(:orgs, [
             Org.create!(
               name: 'Name',
               location: nil
             ),
             Org.create!(
               name: 'Name',
               location: nil
             )
           ])
  end

  it 'renders a list of orgs' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
  end
end
