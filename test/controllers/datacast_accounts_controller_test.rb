require 'test_helper'

class DatacastAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @datacast_account = datacast_accounts(:one)
  end

  test "should get index" do
    get datacast_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_datacast_account_url
    assert_response :success
  end

  test "should create datacast_account" do
    assert_difference('DatacastAccount.count') do
      post datacast_accounts_url, params: { datacast_account: { account_id: @datacast_account.account_id, datacast_id: @datacast_account.datacast_id, is_active: @datacast_account.is_active } }
    end

    assert_redirected_to datacast_account_url(DatacastAccount.last)
  end

  test "should show datacast_account" do
    get datacast_account_url(@datacast_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_datacast_account_url(@datacast_account)
    assert_response :success
  end

  test "should update datacast_account" do
    patch datacast_account_url(@datacast_account), params: { datacast_account: { account_id: @datacast_account.account_id, datacast_id: @datacast_account.datacast_id, is_active: @datacast_account.is_active } }
    assert_redirected_to datacast_account_url(@datacast_account)
  end

  test "should destroy datacast_account" do
    assert_difference('DatacastAccount.count', -1) do
      delete datacast_account_url(@datacast_account)
    end

    assert_redirected_to datacast_accounts_url
  end
end
