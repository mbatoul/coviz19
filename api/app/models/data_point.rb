# frozen_string_literal: true

class DataPoint < ApplicationRecord
  belongs_to :zone

  scope :just_before, -> (date) { where('date < (?)', date).order(date: :desc).limit(1) }

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

  def self.execute_sql(*sql_array)     
    connection.execute(send(:sanitize_sql_array, sql_array))
  end
end
