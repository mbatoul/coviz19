desc 'Imports countries geojson features from AWS S3 server'

task import_geographical_data: :environment do
  ImportGeographicalDataService.call
end