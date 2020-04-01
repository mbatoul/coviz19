# frozen_string_literal: true

class ChartDataService
  COLORS = %w[#3273dc #ffdb4a #35AC5E #FF3860 #8c3193 #173f7f #ff863d #2A7E47 #ac1433 #899058]
  WORLD_COLOR = '#BCBCBC'

  def initialize(zones_names, category, start_date, end_date, scale)
    @zones = Zone.where(kebab_name: zones_names)
    @is_world_included = zones_names.include?('world')
    @category = category
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @scale = scale
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    format_data
  end

  def format_data
    data = {
      datasets: []
    }
    @zones.each_with_index do |zone, index|
      data[:datasets] << {
        data: zone_data(zone),
        label: zone.name,
        borderColor: COLORS[index],
        fill: false,
        borderWidth: 4,
        pointRadius: 0
      }
    end
    
    if @is_world_included
      data[:datasets] << {
        data: world_data,
        label: 'World',
        borderColor: WORLD_COLOR,
        fill: false,
        borderWidth: 4,
        pointRadius: 0
      }
    end
    data
  end

  def zone_data(zone)
    data = []

    zone_ids = zone.all_children.map(&:id) << zone.id
    
    if @scale == 'logarithmic'
      query = '
        SELECT date,
        CASE 
          WHEN SUM(value) > 0 THEN LOG(SUM(value))
          ELSE 0
        END as total
        FROM data_points
      '
    else
      query = '
        SELECT date, sum(value) AS total
        FROM data_points 
      '
    end
    query += '
      WHERE date >= (?)
      AND date <= (?)
      AND category = (?)
      AND zone_id IN (?)
      GROUP BY date
      ORDER BY date
    '
    results = DataPoint.execute_sql(
      query,
      @start_date,
      @end_date,
      DataPoint.categories[@category],
      zone_ids
    )
    results.each do |result|
      data << {
        x: result['date'].to_date.strftime('%d/%m/%y'),
        y: result['total']
      }
    end

    data
  end
  
  def world_data
    data = []
    query = '
      SELECT date, sum(value) AS total
      FROM data_points
      WHERE date >= (?)
      AND date <= (?)
      AND category IN (?)
      GROUP BY date
      ORDER BY date
    '
    results = DataPoint.execute_sql(
      query,
      @start_date,
      @end_date,
      DataPoint.categories[@category],
    )
    results.each do |result|
      data << {
        x: result['date'].to_date.strftime('%d/%m/%y'),
        y: result['total']
      }
    end
    data
  end
end
