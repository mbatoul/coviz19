# frozen_string_literal: true

class V1::GeojsonFeaturesController < ApplicationController
  # GET /geojson_features
  # GET /geojson_features.json
  def index
    respond_to do |format|
      format.json {
        @geojson_features = GeojsonFeature.with_zones.
          where('zones.lat IS NOT NULL').
          where('zones.lng IS NOT NULL').
          pluck(:feature)
      }

      format.csv {
        send_data GeojsonFeature.to_csv, filename: 'geojson-features.csv'
      }
    end
  end
end
