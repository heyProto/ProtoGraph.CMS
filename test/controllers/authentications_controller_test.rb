require 'test_helper'

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authentication = authentications(:one)
  end

  test "should get index" do
    get authentications_url
    assert_response :success
  end

  test "should get new" do
    get new_authentication_url
    assert_response :success
  end

  test "should create authentication" do
    assert_difference('Authentication.count') do
      post authentications_url, params: { authentication: { access_token: @authentication.access_token, access_token_secret: @authentication.access_token_secret, account_id: @authentication.account_id, created_by: @authentication.created_by, email: @authentication.email, info: @authentication.info, name: @authentication.name, provider: @authentication.provider, refresh_token: @authentication.refresh_token, token_expires_at: @authentication.token_expires_at, uid: @authentication.uid, updated_by: @authentication.updated_by } }
    end

    assert_redirected_to authentication_url(Authentication.last)
  end

  test "should show authentication" do
    get authentication_url(@authentication)
    assert_response :success
  end

  test "should get edit" do
    get edit_authentication_url(@authentication)
    assert_response :success
  end

  test "should update authentication" do
    patch authentication_url(@authentication), params: { authentication: { access_token: @authentication.access_token, access_token_secret: @authentication.access_token_secret, account_id: @authentication.account_id, created_by: @authentication.created_by, email: @authentication.email, info: @authentication.info, name: @authentication.name, provider: @authentication.provider, refresh_token: @authentication.refresh_token, token_expires_at: @authentication.token_expires_at, uid: @authentication.uid, updated_by: @authentication.updated_by } }
    assert_redirected_to authentication_url(@authentication)
  end

  test "should destroy authentication" do
    assert_difference('Authentication.count', -1) do
      delete authentication_url(@authentication)
    end

    assert_redirected_to authentications_url
  end
end
