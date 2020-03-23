json.set! :zones do
  @zones.each do |zone|
    json.set! zone.parameterized_name do
      json.name zone.name
      json.lat zone.lat
      json.lng zone.lng
      json.isoCode zone.code
      json.values do
        json.death zone.total('death')
        json.confirmed zone.total('confirmed')
        json.recovered zone.total('recovered')
      end
    end
  end

  json.world do
    json.values do
      json.death Zone.current_total('death')
      json.confirmed Zone.current_total('confirmed')
      json.recovered Zone.current_total('recovered')
    end
  end

end

json.ceilings do
  json.death DataPoint.most_recent_by_zone.where(category: 'death').pluck(:value).max
  json.confirmed DataPoint.most_recent_by_zone.where(category: 'confirmed').pluck(:value).max
  json.recovered DataPoint.most_recent_by_zone.where(category: 'recovered').pluck(:value).max
end