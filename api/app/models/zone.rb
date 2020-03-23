class Zone < ApplicationRecord
  belongs_to :parent, class_name: 'Zone', optional: true
  has_many :children, class_name: 'Zone', foreign_key: 'parent_id'
  has_many :data_points, dependent: :delete_all
  has_one :geojson_feature

  enum nature: [
    :state,
    :province,
    :region,
    :country
  ]

  scope :countries, -> { where(nature: 'country') }

  def all_children(children_array = [])
    children_array += children

    children.each do |child|
      return child.all_children(children_array)
    end

    children_array
  end

  def self.current_total(category)
    DataPoint.where(category: category).
      most_recent_by_zone.
      sum(:value)
  end

  def total(category, opts = {})
    DataPoint.includes(:zone).
      where(zone_id: [id, all_children.map(&:id)].flatten).
      where(category: category).
      most_recent_by_zone.
      sum(:value)
  end

  def diff_between(from, to, category)
    return if to < from

    total(category, date: from) - total(category, date: to)
  end
end
