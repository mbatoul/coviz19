class ZonesController < ApplicationController
  # GET /zones
  # GET /zones.json
  def index
    @zones = Zone.where.not(lat: nil).where.not(lng: nil)
  end

  # GET /zones
  # GET /zones.json
  def historical_data
    # params[:zones]
    # params[:start_date]
    # params[:end_date]
  end
end
