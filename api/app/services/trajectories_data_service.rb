# frozen_string_literal: true

class TrajectoriesDataService
  include Service
  attr_accessor :category

  COLORS = %w[#d00000 #ffba08 #3f88c5 #032b43 #136f63]
  DEFAULT_COLOR = '#BCBCBC'
  NUMBER_OF_COLORED_COUNTRIES = 5
  THRESHOLDS = {
    confirmed: 100,
    death: 10,
    recovered: 50
  }.freeze

  def call
    result_data = {
      datasets: []
    }

    countries = Zone.countries

    countries_with_colors = countries.sort_by { |country| country.total(@category) }.last(NUMBER_OF_COLORED_COUNTRIES).map(&:kebab_name)

    colors_per_countries = Hash[countries_with_colors.zip COLORS]
    
    countries.each do |country|
      data = []
      zone_ids = country.all_children.map(&:id) << country.id
      
      query = '
        SELECT date, sum(value) as total
        FROM data_points
        WHERE category = (?)
        AND zone_id IN (?)
        GROUP BY date
        HAVING sum(value) > (?)
        ORDER BY date
      '
      
      results = DataPoint.execute_sql(
        query,
        DataPoint.categories[@category],
        zone_ids,
        THRESHOLDS[@category.to_sym]
      )

      next if results.first.nil?

      results.each do |result|
        diff = result['date'].to_date - results.first['date'].to_date
        data << {
          x: diff.to_i,
          y: result['total']
        }
      end

      coloured = colors_per_countries[country.kebab_name].present?

      result_data[:datasets] << {
        data: data,
        label: country.name,
        borderColor: colors_per_countries[country.kebab_name] || DEFAULT_COLOR,
        fill: false,
        borderWidth: coloured ? 3 : 2,
        pointRadius: coloured ? 3 : 0
      }
    end

    result_data
  end
end
