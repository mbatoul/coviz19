class RawDataService
  include Service
  attr_accessor :date, :parent_only

  def call
    if @parent_only
      zones = Zone.where(nature: 'country')
    else
      zones = Zone.where.not(parent_id: nil)
    end

    zones.map do |zone|
      {
        child_name: zone.name,
        parent_name: zone.parent&.name || zone.name,
        confirmed: zone.total('confirmed'),
        death: zone.total('death'),
        recovered: zone.total('recovered'),
      }
    end
  end
end