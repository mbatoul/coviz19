class ZonePresenter
  def initialize(zone)
    @zone = zone
  end

  def fmt_total(category, opts = {})
    { 
      name: @zone.name,
      parameterized_name: @zone.parameterized_name,
      total: @zone.total(category, date: opts[:date])
    }
  end

  def fmt_zone
    {
      name: @zone.name,
      parameterized_name: @zone.parameterized_name,
      lat: @zone.lat,
      lng: @zone.lng,
      values: {
        death: @zone.total('death'),
        confirmed: @zone.total('confirmed'),
        recovered: @zone.total('recovered'),
      }
    }
  end

  def self.fmt_world
    {
      name: 'World',
      parameterized_name: 'world',
      values: {
        death: Zone.total('death'),
        confirmed: Zone.total('confirmed'),
        recovered: Zone.total('recovered'),
      }
    }
  end

  def self.fmt_zones
    zones = Zone.where('lat IS NOT NULL AND lng IS NOT NULL')
    zones = zones.map { |zone| ZonePresenter.new(zone).fmt_zone }
    zones.merge!{
      ZonePresenter.fmt_world
    }
    zones
  end
end