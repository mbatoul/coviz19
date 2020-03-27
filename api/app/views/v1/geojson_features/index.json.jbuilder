json.geojson_features do
  json.type 'FeatureCollection'
  json.features do
    json.array! @geojson_features
  end
end