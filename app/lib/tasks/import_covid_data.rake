desc 'Imports historical data points from CSSE'

task import_covid_data: :environment do
  ImportCovidDataService.call
end