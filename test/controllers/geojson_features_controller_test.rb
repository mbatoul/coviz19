require 'test_helper'

class GeojsonFeaturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geojson_feature = geojson_features(:one)
  end

  test "should get index" do
    get geojson_features_url, as: :json
    assert_response :success
  end

  test "should create geojson_feature" do
    assert_difference('GeojsonFeature.count') do
      post geojson_features_url, params: { geojson_feature: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show geojson_feature" do
    get geojson_feature_url(@geojson_feature), as: :json
    assert_response :success
  end

  test "should update geojson_feature" do
    patch geojson_feature_url(@geojson_feature), params: { geojson_feature: {  } }, as: :json
    assert_response 200
  end

  test "should destroy geojson_feature" do
    assert_difference('GeojsonFeature.count', -1) do
      delete geojson_feature_url(@geojson_feature), as: :json
    end

    assert_response 204
  end
end
