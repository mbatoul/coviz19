# frozen_string_literal: true

class TrajectoriesDataService
  COLORS = %w[#3273dc #ffdb4a #35AC5E #FF3860 #8c3193 #173f7f #ff863d #2A7E47 #ac1433 #899058]
  WORLD_COLOR = '#646464'
  THRESHOLD = 100
  CHART_TITLES = {
    confirmed: "Cumulative number of confirmed cases, by number of days since #{THRESHOLD}th confirmed case",
    active: "Cumulative number of active cases, by number of days since #{THRESHOLD}th active case",
    death: "Cumulative number of deaths cases, by number of days since #{THRESHOLD}th death",
    recovered: "Cumulative number of recovered cases, by number of days since #{THRESHOLD}th recovery",
  }.freeze
  X_AXES_TITLES = {
    confirmed: "Number of days since the #{THRESHOLD}th confirmed case",
    active: "Number of days since the #{THRESHOLD}th active case",
    death: "Number of days since the #{THRESHOLD}th death",
    recovered: "Number of days since the #{THRESHOLD}th recovery",
  }.freeze
  CATEGORIES = %w[confirmed active death recovered]
  
  def initialize(zones:, is_log_scale:, world_only:)
    @zones = zones
    @is_log_scale = is_log_scale
    @world_only = world_only
    @colors_per_zones = Hash[@zones.map(&:kebab_name).zip COLORS]
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
              SELECT date, sum(value) as total
            '
          end
        query += '
          FROM data_points
          WHERE category = (?)
          AND zone_id IN (?)
          GROUP BY date
          HAVING sum(value) > (?)
          ORDER BY date
        '
        
        results = DataPoint.execute_sql(
          query,
          DataPoint.categories[category],
          zone_ids,
          THRESHOLD
        )
  
        next if results.first.nil?
  
        results.each do |result|
          diff = result['date'].to_date - results.first['date'].to_date
          data << {
            x: diff.to_i,
            y: result['total']
          }
        end
    
        category_chart_data[:datasets] << {
          data: data,
          label: zone.name,
          borderColor: @colors_per_zones[zone.kebab_name],
          backgroundColor: @colors_per_zones[zone.kebab_name],
          fill: false,
          borderWidth: 3,
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
            SELECT date, sum(value) as total
          '
        end
      query += '
        FROM data_points
        WHERE category = (?)
        GROUP BY date
        HAVING sum(value) > (?)
        ORDER BY date
      '
      
      results = DataPoint.execute_sql(
        query,
        DataPoint.categories[category],
        THRESHOLD
      )

      next if results.first.nil?

      results.each do |result|
        diff = result['date'].to_date - results.first['date'].to_date
        data << {
          x: diff.to_i,
          y: result['total']
        }
      end
  
      category_chart_data[:datasets] << {
        data: data,
        label: 'World',
        borderColor: WORLD_COLOR,
        backgroundColor: WORLD_COLOR,
        fill: false,
        borderWidth: 3,
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
        text: CHART_TITLES[category.to_sym],
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
          type: "linear",
          scaleLabel: {
            display: true,
            labelString: X_AXES_TITLES[category.to_sym],
            fontSize: 14
          },
          gridLines: {
            drawOnChartArea:false
          }
        }],
        yAxes: [
          {
            ticks: {
              precision: 0,
              beginAtZero: true,
              position: 'left'
            },
            gridLines: {
              drawOnChartArea:false
            }
          },
        ],
      }
    }
  end
end
