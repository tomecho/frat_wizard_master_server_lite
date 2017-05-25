require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { create :group }

  it 'has a valid factory' do
    expect(group).to be_valid
  end

  context 'table relationships' do
    it 'has_many users' do
      users = create_list :user, 5
      expect(create(:group, users: users)).to have_attributes users: users
    end
  end

  context 'validations' do
    context 'enforcing uniqueness on name and desc within same org id' do
      it 'does it for name' do
        org = create :org
        create :group, name: 'test', org: org
        expect { create :group, name: 'test', org: org }.to raise_error ActiveRecord::RecordInvalid, /Name has already been taken/
      end

      it 'does it for desc' do
        org = create :org
        create :group, description: 'test', org: org
        expect { create :group, description: 'test', org: org }.to raise_error ActiveRecord::RecordInvalid, /Description has already been taken/
      end
    end
  end
end
