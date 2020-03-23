require 'test_helper'

class DataPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @data_point = data_points(:one)
  end

  test "should get index" do
    get data_points_url, as: :json
    assert_response :success
  end

  test "should create data_point" do
    assert_difference('DataPoint.count') do
      post data_points_url, params: { data_point: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show data_point" do
    get data_point_url(@data_point), as: :json
    assert_response :success
  end

  test "should update data_point" do
    patch data_point_url(@data_point), params: { data_point: {  } }, as: :json
    assert_response 200
  end

  test "should destroy data_point" do
    assert_difference('DataPoint.count', -1) do
      delete data_point_url(@data_point), as: :json
    end

    assert_response 204
  end
end
