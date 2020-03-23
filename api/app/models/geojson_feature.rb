class GeojsonFeature < ApplicationRecord
  belongs_to :zone, optional: true
  scope :with_zones, -> { joins(:zone) }
end
