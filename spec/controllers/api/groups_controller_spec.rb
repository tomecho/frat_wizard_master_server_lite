# frozen_string_literal: true
require 'rails_helper'

describe GroupsController do
  let!(:group) { create(:group) }
  let!(:group2) { create(:group) }

  let(:group_attr) { attributes_for(:group).merge(org_id: create(:org).id) }
  let(:group_with_users_and_perms) {attributes_for(:group).merge(org_id: create(:org).id, user_ids: create_list(:user, 5).map(&:id),
                                                                 permission_ids: create_list(:permission,5).map(&:id))}

  describe 'GET #index' do
    it 'populates an array of groups' do
      create_list :group, 5 # add a few more groups
      get :index
      expect(response.body).to eq(Group.all.to_json) # will list all groups
    end
  end

  describe 'GET #show' do
    it 'assigns the requested group to @group' do
      get :show, params: { id: group }
      expect(assigns[:group]).to eq(group)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new group in the database' do
        expect do
          post :create, params: { group: group_attr }
        end.to change(Group, :count).by(1)
      end
      it 'attaches the group to users and permissions' do
        post :create, params: { group: group_with_users_and_perms}
        expect(Group.last.users.map(&:id)).to eq(group_with_users_and_perms[:user_ids])
        expect(Group.last.permissions.map(&:id)).to eq(group_with_users_and_perms[:permission_ids])
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect do
          post :create, params: { group: { invalid: 'attr' } }
        end.to_not change(Group, :count)
      end
    end
  end

  describe 'POST #update' do
    context 'with valid attributes' do
      it 'updates the group in the database' do
        new_name = group.name + 'new'
        post :update, params: { id: group, group: { name: new_name } }
        group.reload
        expect(group.name).to eq(new_name)
      end
      it 'updates the groups attached users and permissions' do
        post :create, params: { group: group_with_users_and_perms }
        expect(Group.last.users.map(&:id)).to eq(group_with_users_and_perms[:user_ids])
        expect(Group.last.permissions.map(&:id)).to eq(group_with_users_and_perms[:permission_ids])
      end
    end

    context 'with invalid attributes' do
      it 'does not save the contact in the database' do
        old_name = group.name
        post :update, params: { id: group, group: {random: 'param'} }
        group.reload
        expect(group.name).to eq(old_name)
      end
    end
  end

  describe 'POST #destroy' do
    it 'deletes the group from the database' do
      group
      expect do
        delete :destroy, params: { id: group }
      end.to change(Group, :count).by(-1)
    end
  end

  describe 'DELETE #remove_permission' do
    it 'removes the permission from the group' do
      old_permission = create(:permission)
      group.permissions << old_permission
      user = create(:user)
      group.users << user
      expect(user).to have_permission old_permission.controller, old_permission.action # should have permission to begin with

      delete :remove_permission, params: { id: group.id, permission_id: old_permission.id }

      group.reload
      expect(group.permissions).not_to include(old_permission) # groups wont have permission
      user.reload
      expect(group.group_users.find_by(user_id: user.id)).to be_present # still in group
      expect(user).not_to have_permission old_permission.controller, old_permission.action # but doesnt have permission now
    end
  end

  describe 'POST #create_permission' do
    it 'creates the permission in the group' do
      permission = create(:permission)

      expect(group.permissions).not_to include(permission)

      post :add_permission, params: { id: group.id, permission_id: permission.id }

      group.reload
      expect(group.permissions).to include(permission)
      user = create(:user, groups: [group])
      expect(user).to have_permission permission.controller, permission.action
    end
  end

  describe 'DELETE #remove_user' do
    it 'removes the user in the group' do
      old_user = create(:user)
      group.users << old_user

      expect(group.users).to include(old_user)

      post :remove_user, params: { id: group.id, user_id: old_user.id }

      group.reload
      expect(group.users).not_to include(old_user)
    end

    it 'denies permissions after removed' do
      permission = create(:permission, controller: 'fake controller', action: 'show' )
      permission2 = create(:permission, controller: 'fake controller', action: 'index')

      group.permissions << permission
      group2.permissions << permission2
      user = create(:user)
      user.groups << group
      user.groups << group2
      expect(user).to have_permission permission.controller, permission.action
      post :remove_user, params: { id: group.id, user_id: user.id }
      expect(user).not_to have_permission permission.controller, permission.action
    end
  end

  describe 'POST #add_user' do
    it 'adds the user to the group' do
      user = create(:user)

      expect(group.users).not_to include user

      post :add_user, params: { id: group.id, user_id: user.id }

      group.reload
      expect(group.users).to include(user)
    end
  end
end
