# frozen_string_literal: true

class V1::ZonesController < ApplicationController
  # GET /zones
  # GET /zones.json
  def index
    @zones = Zone.where('lat IS NOT NULL AND lng IS NOT NULL')
    @most_recent_data_points_by_zone = DataPoint.most_recent_by_zone
    @last_update_date = DataPoint.maximum(:date).strftime('%b %d, %Y')
  end

  # GET /zones
  # GET /zones.json
  def chart_data
    @death_chart_data = ChartDataService.call(
      params[:zones],
      'death',
      params[:start_date],
      params[:end_date]
    )
    @confirmed_chart_data = ChartDataService.call(
      params[:zones],
      'confirmed',
      params[:start_date],
      params[:end_date]
    )
    @recovered_chart_data = ChartDataService.call(
      params[:zones],
      'recovered',
      params[:start_date],
      params[:end_date]
    )
  end

  def trajectories_data
    @confirmed_threshold = TrajectoriesDataService::THRESHOLDS[:confirmed]
    @death_threshold = TrajectoriesDataService::THRESHOLDS[:death]
    @recovered_threshold = TrajectoriesDataService::THRESHOLDS[:recovered]

    @confirmed_data = TrajectoriesDataService.call('confirmed')
    @death_data = TrajectoriesDataService.call('death')
    @recovered_data = TrajectoriesDataService.call('recovered')
  end
end
