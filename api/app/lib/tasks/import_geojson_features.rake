desc 'Imports countries geojson features from AWS S3 server'

task import_geojson_features: :environment do
  Import::GeojsonFeaturesService.call
end