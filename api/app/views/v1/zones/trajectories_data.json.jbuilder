json.cache! expired_in: 12.hours do
  json.death_data @death_data
  json.confirmed_data @confirmed_data
  json.recovered_data @recovered_data
  json.death_threshold @death_threshold
  json.confirmed_threshold @confirmed_threshold
  json.recovered_threshold @recovered_threshold
end