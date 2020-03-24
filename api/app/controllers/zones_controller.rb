class ZonesController < ApplicationController
  # GET /zones
  # GET /zones.json
  def index
    @zones = Zone.where('lat IS NOT NULL AND lng IS NOT NULL')
    @most_recent_data_points_by_zone = DataPoint.most_recent_by_zone
  end

  # GET /zones
  # GET /zones.json
  def historical_data
    # params[:zones]
    # params[:start_date]
    # params[:end_date]
    p params[:zones]
    p params[:start_date]
    p params[:end_date]
  end
end
