class GeojsonFeaturesController < ApplicationController
  # GET /geojson_features
  # GET /geojson_features.json
  def index
    @geojson_features = GeojsonFeature.with_zones.where('zones.lat IS NOT NULL').where('zones.lng IS NOT NULL').pluck(:feature)
  end
end
