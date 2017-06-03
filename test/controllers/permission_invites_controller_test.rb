require 'test_helper'

class PermissionInvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @permission_invite = permission_invites(:one)
  end

  test "should get index" do
    get permission_invites_url
    assert_response :success
  end

  test "should get new" do
    get new_permission_invite_url
    assert_response :success
  end

  test "should create permission_invite" do
    assert_difference('PermissionInvite.count') do
      post permission_invites_url, params: { permission_invite: { account_id: @permission_invite.account_id, created_by: @permission_invite.created_by, email: @permission_invite.email, updated_by: @permission_invite.updated_by } }
    end

    assert_redirected_to permission_invite_url(PermissionInvite.last)
  end

  test "should show permission_invite" do
    get permission_invite_url(@permission_invite)
    assert_response :success
  end

  test "should get edit" do
    get edit_permission_invite_url(@permission_invite)
    assert_response :success
  end

  test "should update permission_invite" do
    patch permission_invite_url(@permission_invite), params: { permission_invite: { account_id: @permission_invite.account_id, created_by: @permission_invite.created_by, email: @permission_invite.email, updated_by: @permission_invite.updated_by } }
    assert_redirected_to permission_invite_url(@permission_invite)
  end

  test "should destroy permission_invite" do
    assert_difference('PermissionInvite.count', -1) do
      delete permission_invite_url(@permission_invite)
    end

    assert_redirected_to permission_invites_url
  end
end
