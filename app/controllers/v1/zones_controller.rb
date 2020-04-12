# frozen_string_literal: true

class V1::ZonesController < ApplicationController
  # GET /zones
  # GET /zones.json
  def index
    @zones = Zone.where('lat IS NOT NULL AND lng IS NOT NULL')
    @most_recent_data_points_by_zone = DataPoint.most_recent_by_zone
  end

  # GET /charts_data
  # GET /charts_data.json
  def charts_data
    is_log_scale = params[:is_log_scale] == 'true'
    world_only = params[:world_only] == 'true'
    
    @charts_data = 
      case params[:visualization_mode]
      when 'cumulative', 'prevalence'
        ChartDataService.call(
          zones: Zone.where(kebab_name: params[:zones_names]),
          start_date: Date.parse(params[:start_date]),
          end_date: Date.parse(params[:end_date]),
          visualization_mode: params[:visualization_mode],
          is_log_scale: is_log_scale,
          world_only: world_only
        )
      when 'trajectories'
        TrajectoriesDataService.call(
          zones: Zone.where(kebab_name: params[:zones_names]),
          is_log_scale: is_log_scale,
          world_only: world_only
        )
      end
  end

  def raw_data
    if params[:parent_only] == 'true'
      @raw_data = RawDataService.call(parent_only: true)
    else
      @raw_data = RawDataService.call(parent_only: false)
    end
  end
end
