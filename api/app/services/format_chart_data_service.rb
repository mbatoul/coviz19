# frozen_string_literal: true

class FormatChartDataService
  COLORS = %w[#36a3eb #4bc0c0 ​#ffa040 #9966ff #ff6385 #ffcc56].freeze

  def initialize(zones_names, categories, start_date, end_date)
    @zones = Zone.where(kebab_name: zones_names)
    @categories = categories
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @is_world = zones_names == ['world']
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    data = format_data

    p data
  end

  def format_data
    data = {
      datasets: []
    }
    if @is_world

    else
      @zones.each_with_index do |zone, index|
        data[:datasets] << {
          data: data(zone),
          label: zone.name,
          borderColor: COLORS[index],
          fill: false,
          borderWidth: 4,
          pointRadius: 0
        }
      end
    end
    data
  end

  def data(zone)
    data = []

    zone.data_points
      .where('date >= (?) AND date <= (?)', @start_date, @end_date).
      where(category: @categories).
      each do |data_point|

        data << {
          x: data_point.date.strftime('%d/%m/%y'),
          y: data_point.value
        }
      end

    data
  end
  
  def labels
    (@start_date..@end_date).group_by(&:cweek)
    .values
    .map { |group| group.first.strftime('%b %d, %Y') }
  end
end