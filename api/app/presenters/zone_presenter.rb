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
end