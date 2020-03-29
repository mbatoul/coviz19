# frozen_string_literal: true

class TrajectoriesDataService
  COLORS = %w[#d00000 #ffba08 #3f88c5 #032b43 #136f63]
  DEFAULT_COLOR = '#BCBCBC'
  NUMBER_OF_COLORED_ZONES = 5
  THRESHOLDS = {
    confirmed: 100,
    active: 100,
    death: 10,
    recovered: 50
  }.freeze
  
  def initialize
    DataPoint.categories.keys.each do |category|
      instance_variable_set("@#{category}", call(category))
      self.class.send(:attr_accessor, category)
    end
    @zones = Zone.countries.order(:id)
    colored_zones = @zones.sort_by { |zone| DataPoint.where(zone_id: [zone.all_children.map(&:id) << zone.id]).sum(:value) }.
      last(NUMBER_OF_COLORED_ZONES).
      map(&:kebab_name)
    @colors_per_zones = Hash[colored_zones.zip COLORS]
  end

  def call(category)
    result_data = {
      datasets: []
    }

    @zones.each do |zone|
      data = []
      zone_ids = zone.all_children.map(&:id) << zone.id
      
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
        DataPoint.categories[category],
        zone_ids,
        THRESHOLDS[category.to_sym]
      )

      next if results.first.nil?

      results.each do |result|
        diff = result['date'].to_date - results.first['date'].to_date
        data << {
          x: diff.to_i,
          y: result['total']
        }
      end

      coloured = @colors_per_zones[zone.kebab_name].present?

      result_data[:datasets] << {
        data: data,
        label: zone.name,
        borderColor: @colors_per_zones[zone.kebab_name] || DEFAULT_COLOR,
        fill: false,
        borderWidth: coloured ? 3 : 2,
        pointRadius: coloured ? 3 : 0
      }
    end

    result_data
  end
end
