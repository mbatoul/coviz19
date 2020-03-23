# frozen_string_literal: true

# Takes a geojon feature and finds the corresponding zone.
class CoupleFeatureWithZoneService
  include Service

  SEARCHABLE_PROPERTIES = %w[sovereignt adm0_a3 postal name].freeze

  EXCEPTIONS = {
    'United States of America': 'US'
  }.freeze

  def initialize(feature)
    @properties = feature['properties']
  end

  def call
    find_zone
  end

  private

  def find_zone
    zone = nil

    SEARCHABLE_PROPERTIES.each do |searchable_property|
      value = EXCEPTIONS[@properties[searchable_property].to_sym] || @properties[searchable_property]

      begin
        zone = find_with(value)
      rescue ZoneNotFoundError => e
        Rails.logger.error "No zone found for #{value}"
      rescue MultipleZonesFoundError => e
        Rails.logger.error "Multiple zone found for #{value}"
      end
    end

    zone
  end

  class ZoneNotFoundError < StandardError
  end

  class MultipleZonesFoundError < StandardError
  end

  def find_with(value)
    value = value.parameterize
    zone = Zone.countries.find_by('parameterized_name ILIKE (?)', "#{value}")
    
    return zone if zone.present?

    splitted = value.split(/\W|\s/)
    size = splitted.size

    if size > 1
      zones = []

      (1..size).each do |i|
        splitted.combination(i).each do |combination|
          query = "#{combination.join('-')}"
          result = Zone.countries.
            where('parameterized_name ILIKE (?)', query).
            joins('LEFT JOIN geojson_features ON geojson_features.zone_id = zones.id').
            where('geojson_feature.zone_id IS NULL')
          zones << result
        end
      end

      raise ZoneNotFoundError if zones.empty?
      raise MultipleZonesFoundError if zones.size > 1

      zone = zones.first
    end

    zone
  end
end
