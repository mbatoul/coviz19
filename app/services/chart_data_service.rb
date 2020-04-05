# frozen_string_literal: true

class ChartDataService
  COLORS = %w[#3273dc #ffdb4a #35AC5E #FF3860 #8c3193 #173f7f #ff863d #2A7E47 #ac1433 #899058]
  WORLD_COLOR = '#646464'
  CATEGORIES = %w[confirmed active death recovered]

  def initialize(zones:, start_date:, end_date:, is_log_scale:, visualization_mode:, world_only:)
    @zones = zones
    @start_date = start_date
    @end_date = end_date
    @is_log_scale = is_log_scale
    @visualization_mode = visualization_mode
    @colors_per_zones = Hash[@zones.map(&:kebab_name).zip COLORS]
    @world_only = world_only
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    @world_only ? format_world_data : format_zones_data
  end

  def format_zones_data
    charts_data = []

    CATEGORIES.each do |category|
      category_chart_data = {
        datasets: []
      }
      @zones.each do |zone|
        data = []

        zone_ids = zone.all_children.map(&:id) << zone.id
        
        query = 
          if @is_log_scale
            '
              SELECT date,
              CASE 
                WHEN SUM(value) > 0 THEN LOG(SUM(value))
                ELSE 0
              END as total
            '
          else
            '
              SELECT date, sum(value) AS total 
            '
          end
        query += '
          FROM data_points
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
          DataPoint.categories[category],
          zone_ids
        )
        results.each do |result|
          data << {
            x: result['date'].to_date.strftime('%d/%m/%y'),
            y: result['total']
          }
        end

        category_chart_data[:datasets] << {
          data: data,
          label: zone.name,
          borderColor: @colors_per_zones[zone.kebab_name],
          backgroundColor: @colors_per_zones[zone.kebab_name],
          fill: false,
          borderWidth: 4,
          pointRadius: 0
        }
      end
      charts_data << {
        chart_data: category_chart_data,
        chart_options: chart_options(category)
      }
    end
    charts_data
  end
  
  def format_world_data
    charts_data = []
    CATEGORIES.each do |category|
      category_chart_data = {
        datasets: []
      }

      data = []

      query = 
        if @is_log_scale
          '
            SELECT date,
            CASE 
            WHEN SUM(value) > 0 THEN LOG(SUM(value))
            ELSE 0
            END as total
          '
        else
          '
            SELECT date, sum(value) AS total
          '
        end
      query += '
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
        DataPoint.categories[category],
      )
      results.each do |result|
        data << {
          x: result['date'].to_date.strftime('%d/%m/%y'),
          y: result['total']
        }
      end

      category_chart_data[:datasets] << {
        data: data,
        label: 'World',
        borderColor: WORLD_COLOR,
        backgroundColor: WORLD_COLOR,
        fill: false,
        borderWidth: 4,
        pointRadius: 0
      }
      
      charts_data << {
        chart_data: category_chart_data,
        chart_options: chart_options(category)
      }
    end
    charts_data
  end

  def chart_options(category)
    {
      responsive: true,
      maintainAspectRatio: false,
      scaleBeginAtZero: true,
      title: {
        display: true,
        text: category.capitalize,
        fontSize: 16,
        position: 'top'
      },
      tooltips: {
        mode: 'nearest',
        intersect: false,
      },
      hover: {
        enabled: false,
        mode: 'nearest',
        intersect: true
      },
      scales: {
        xAxes: [{
          type: "time",
          time: {
            format: 'DD/MM/YYYY',
            tooltipFormat: 'll',
            unit: 'day'
          },
          gridLines: {
            drawOnChartArea:false
          }
        }],
        yAxes: [{
          ticks: {
            precision: 0,
            beginAtZero: true,
          },
          gridLines: {
            drawOnChartArea:false
          }
        }],
      }
    }
  end
end
