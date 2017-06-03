require 'test_helper'

class DatacastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @datacast = datacasts(:one)
  end

  test "should get index" do
    get datacasts_url
    assert_response :success
  end

  test "should get new" do
    get new_datacast_url
    assert_response :success
  end

  test "should create datacast" do
    assert_difference('Datacast.count') do
      post datacasts_url, params: { datacast: { count_duplicate_calls: @datacast.count_duplicate_calls, count_errors: @datacast.count_errors, count_publish: @datacast.count_publish, created_by: @datacast.created_by, data: @datacast.data, data_timestamp: @datacast.data_timestamp, error_messages: @datacast.error_messages, external_identifier: @datacast.external_identifier, input_source: @datacast.input_source, last_data_hash: @datacast.last_data_hash, last_updated_at: @datacast.last_updated_at, slug: @datacast.slug, status: @datacast.status, template_datum_id: @datacast.template_datum_id } }
    end

    assert_redirected_to datacast_url(Datacast.last)
  end

  test "should show datacast" do
    get datacast_url(@datacast)
    assert_response :success
  end

  test "should get edit" do
    get edit_datacast_url(@datacast)
    assert_response :success
  end

  test "should update datacast" do
    patch datacast_url(@datacast), params: { datacast: { count_duplicate_calls: @datacast.count_duplicate_calls, count_errors: @datacast.count_errors, count_publish: @datacast.count_publish, created_by: @datacast.created_by, data: @datacast.data, data_timestamp: @datacast.data_timestamp, error_messages: @datacast.error_messages, external_identifier: @datacast.external_identifier, input_source: @datacast.input_source, last_data_hash: @datacast.last_data_hash, last_updated_at: @datacast.last_updated_at, slug: @datacast.slug, status: @datacast.status, template_datum_id: @datacast.template_datum_id } }
    assert_redirected_to datacast_url(@datacast)
  end

  test "should destroy datacast" do
    assert_difference('Datacast.count', -1) do
      delete datacast_url(@datacast)
    end

    assert_redirected_to datacasts_url
  end
end
