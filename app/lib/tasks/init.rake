desc 'Global application initialization'

task init: :environment do
  Zone.destroy_all
  ImportCovidDataService.call
  GeojsonFeature.destroy_all
  ImportGeographicalDataService.call
end