json.cache! expires_in: 12.hours do
  json.set! :zones do
    @zones.each do |zone|
      json.set! zone.kebab_name do
        json.name zone.name
        json.kebab_name zone.kebab_name
        json.parent_kebab_name zone.parent&.kebab_name
        json.svg_flag_name zone.parent&.kebab_name || zone.kebab_name
        json.lat zone.lat
        json.lng zone.lng
        json.values do
          json.death zone.total('death')
          json.confirmed zone.total('confirmed')
          json.recovered zone.total('recovered')
          json.active zone.total('active')
        end
      end
    end

    json.world do
      json.name 'World'
      json.kebab_name 'world'
      json.svg_flag_name 'world'
      json.lat 0
      json.lng 0
      json.values do
        json.death Zone.total('death')
        json.confirmed Zone.total('confirmed')
        json.recovered Zone.total('recovered')
        json.active Zone.total('active')
      end
    end
  end

  json.ceilings do
    json.death DataPoint.where(category: 'death').most_recent_by_zone.sum(:value)
    json.confirmed DataPoint.where(category: 'confirmed').most_recent_by_zone.sum(:value)
    json.recovered DataPoint.where(category: 'recovered').most_recent_by_zone.sum(:value)
    json.active DataPoint.where(category: 'active').most_recent_by_zone.sum(:value)
  end

end
json.last_update_date @last_update_date