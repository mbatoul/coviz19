class DataPoint < ApplicationRecord
  belongs_to :zone
  default_scope { order(:date) }
  scope :most_recent_by_zone, -> do
    from(
      <<~SQL
        (
          SELECT data_points.*
          FROM data_points JOIN (
             SELECT zone_id, max(date) AS date
             FROM data_points
             GROUP BY zone_id
          ) latest_by_zone
          ON data_points.date = latest_by_zone.date
          AND data_points.zone_id = latest_by_zone.zone_id
        ) data_points
      SQL
    )
  end

  enum category: [
    :confirmed,
    :death,
    :recovered
  ]
end
