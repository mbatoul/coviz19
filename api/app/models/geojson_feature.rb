# frozen_string_literal: true

class GeojsonFeature < ApplicationRecord
  belongs_to :zone, optional: true
  scope :with_zones, -> { joins(:zone) }

  def self.to_csv
    attributes = %w[id feature]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |geojson_feature|
        csv << attributes.map{ |attr| geojson_feature.send(attr) }
      end
    end
  end
end
