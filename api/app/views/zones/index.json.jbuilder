json.set! :zones do
  @zones.each do |zone|
    json.set! zone.parameterized_name do
      json.name zone.name
      json.parameterized_name zone.parameterized_name
      json.parent_parameterized_name zone.parent&.parameterized_name
      json.lat zone.lat
      json.lng zone.lng
      json.values do
        json.death zone.total('death')
        json.confirmed zone.total('confirmed')
        json.recovered zone.total('recovered')
      end
    end
  end

  json.world do
    json.name 'World'
    json.parameterized_name 'world'
    json.values do
      json.death Zone.total('death')
      json.confirmed Zone.total('confirmed')
      json.recovered Zone.total('recovered')
    end
  end
end

json.ceilings do
  json.death DataPoint.where(category: 'death').most_recent_by_zone.sum(:value)
  json.confirmed DataPoint.where(category: 'confirmed').most_recent_by_zone.sum(:value)
  json.recovered DataPoint.where(category: 'recovered').most_recent_by_zone.sum(:value)
end